import 'dart:async';
import 'dart:math';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';

/// خدمة بلوتوث موحَّدة تدعم وضعَين:
///
/// 1. **وضع المسح (Scanner)** — يُستخدم من المشرف [LeaderTrackingController]
///    لرصد إشارات الحجاج وتقدير مسافاتهم عبر [initMonitoring].
///
/// 2. **وضع البث (Broadcaster)** — يُستخدم من الحاج [PilgrimTrackingController]
///    لبث إشارة iBeacon كي يتعرف عليها المشرف عبر [initBroadcasting].
///
/// كلا الوضعَين يستخدمان [_initBleWithAdapterMonitoring] المشتركة
/// لإزالة تكرار منطق التهيئة والمراقبة.

class BleRadarService {
  // ─── وضع المسح (Leader) ─────────────────────────────────────────────────

  StreamSubscription<List<ScanResult>>? _bleScanSub;
  StreamSubscription<BluetoothAdapterState>? _scanAdapterStateSub;

  /// مسافات الحجاج المُقدَّرة عبر RSSI — مفتاحها MinorId الحاج.
  final Map<int, double> bleDistances = {};

  /// آخر وقت استقبال إشارة لكل حاج.
  final Map<int, DateTime> lastBleUpdates = {};

  Function(String?)? _onScanWarningChanged;

  /// يُشغِّل رادار المسح ويراقب حالة الـ Adapter تلقائياً.
  Future<void> initMonitoring({Function(String?)? onWarning}) async {
    _onScanWarningChanged = onWarning;
    _scanAdapterStateSub?.cancel();

    _scanAdapterStateSub = await _initBleWithAdapterMonitoring(
      tag: '',
      onWarning: (msg) => _onScanWarningChanged?.call(msg),
      onEnabled: _startActualBleScanning,
      onDisabled: () {
        _bleScanSub?.cancel();
        _onScanWarningChanged?.call(
          'تم إغلاق البلوتوث. دقة تحديد الحجاج القريبين ستنخفض. يرجى تفعيله.',
        );
      },
      notSupportedMessage: 'جهازك لا يدعم البلوتوث.',
    );
  }

  Future<void> _startActualBleScanning() async {
    // ─ فحص GPS قبل البدء (Android يتطلبه لمسح BLE) ────────────────────────
    final bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      debugPrint(
        '⚠️ [رادار البلوتوث] GPS مغلق — سيُعاد المسح تلقائياً عند تفعيله.',
      );
      _onScanWarningChanged?.call('يرجى تفعيل GPS لتشغيل رادار البلوتوث.');
      return; // نخرج بهدوء بدلاً من رمي PlatformException
    }

    debugPrint('📡 [رادار البلوتوث] بدء مسح جديد مستمر...');
    _bleScanSub?.cancel();

    try {
      await FlutterBluePlus.startScan(continuousUpdates: true);
    } on Exception catch (e) {
      debugPrint('❌ [رادار البلوتوث] فشل في بدء المسح: $e');
      _onScanWarningChanged?.call(
        'تعذّر بدء مسح البلوتوث. تأكد من تفعيل GPS والبلوتوث.',
      );
      return;
    }

    int devicesFound = 0;
    _bleScanSub = FlutterBluePlus.scanResults.listen((results) {
      if (results.length != devicesFound) {
        devicesFound = results.length;
        debugPrint(
          '📡 [رادار البلوتوث] عدد الأجهزة المرصودة الآن: $devicesFound جهاز.',
        );
      }
      for (ScanResult r in results) {
        int? extractedMinorId = _extractMinorIdFromBeacon(r);
        if (extractedMinorId != null) {
          int rssi = r.rssi;
          double estimatedDistance = pow(10, (-59 - rssi) / 20.0).toDouble();
          debugPrint(
            '   ✅ [تطابق iBeacon!] رقم الحاج (MinorId): $extractedMinorId | قوة الإشارة: $rssi | المسافة المقدّرة: ${estimatedDistance.toStringAsFixed(2)} متر',
          );
          bleDistances[extractedMinorId] = estimatedDistance;
          lastBleUpdates[extractedMinorId] = DateTime.now();
        }
      }
    });
  }

  int? _extractMinorIdFromBeacon(ScanResult result) {
    final manufacturerData = result.advertisementData.manufacturerData;
    if (manufacturerData.containsKey(76)) {
      final data = manufacturerData[76]!;
      if (data.length >= 23) {
        return (data[20] << 8) + data[21];
      }
    }
    return null;
  }

  /// يوقف المسح ويُفرغ البيانات.
  void stop() {
    _bleScanSub?.cancel();
    _scanAdapterStateSub?.cancel();
    _bleScanSub = null;
    _scanAdapterStateSub = null;
    FlutterBluePlus.stopScan();
    bleDistances.clear();
    lastBleUpdates.clear();
  }

  // ─── وضع البث (Pilgrim) ─────────────────────────────────────────────────

  StreamSubscription<BluetoothAdapterState>? _broadcastAdapterStateSub;
  String? _currentPilgrimId;
  Function(String?)? _onBroadcastWarningChanged;
  final BeaconBroadcast _beaconBroadcast = BeaconBroadcast();

  /// يُشغِّل بث iBeacon ويراقب حالة الـ Adapter لإعادة البث تلقائياً.
  Future<void> initBroadcasting({
    required String pilgrimId,
    Function(String?)? onWarning,
  }) async {
    _currentPilgrimId = pilgrimId;
    _onBroadcastWarningChanged = onWarning;
    _broadcastAdapterStateSub?.cancel();

    _broadcastAdapterStateSub = await _initBleWithAdapterMonitoring(
      tag: ' [الحاج]',
      onWarning: (msg) => _onBroadcastWarningChanged?.call(msg),
      onEnabled: _actuallyStartBeaconBroadcast,
      onDisabled: () {
        _beaconBroadcast.stop();
        _onBroadcastWarningChanged?.call(
          'تم إغلاق البلوتوث. لن يتمكن المشرف من رصدك بدقة. يرجى تفعيله.',
        );
      },
      notSupportedMessage:
          'جهازك لا يدعم البلوتوث — لن يتمكن المشرف من رصدك بدقة.',
    );
  }

  void _actuallyStartBeaconBroadcast() {
    if (_currentPilgrimId == null) return;
    try {
      int numericId = _currentPilgrimId!.hashCode % 65535;
      _beaconBroadcast
          .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
          .setMajorId(1)
          .setMinorId(numericId)
          .start();
      debugPrint(
        '📡 [بلوتوث الحاج] بدأ البث بنجاح كـ iBeacon! رقم الحاج التعريفي: $numericId',
      );
    } catch (e) {
      debugPrint('❌ [بلوتوث الحاج] فشل في بدء البث: $e');
    }
  }

  /// يوقف البث ويُلغي مراقب الـ Adapter.
  void stopBroadcasting() {
    _broadcastAdapterStateSub?.cancel();
    _broadcastAdapterStateSub = null;
    _beaconBroadcast.stop();
    _currentPilgrimId = null;
  }

  // ─── الدالة المشتركة — تُزيل التكرار بين initMonitoring و initBroadcasting ──

  /// تُهيِّئ البلوتوث وتُراقب حالة الـ Adapter.
  ///
  /// تتحقق من دعم البلوتوث، تُحاول تشغيله، ثم تُعيد [StreamSubscription]
  /// يُستدعى فيه [onEnabled] عند تفعيله و[onDisabled] عند إطفائه.
  ///
  /// - [tag]: وسم للـ Debug يُميِّز الوضع (مسح / بث).
  /// - [onWarning]: callback لإرسال تحذير للـ UI أو null لإلغائه.
  /// - [onEnabled]: تُستدعى عند تشغيل البلوتوث (أو كانت مُشغَّلاً).
  /// - [onDisabled]: تُستدعى عند إطفاء البلوتوث.
  /// - [notSupportedMessage]: رسالة تُرسَل إذا كان الجهاز لا يدعم البلوتوث.
  Future<StreamSubscription<BluetoothAdapterState>?>
  _initBleWithAdapterMonitoring({
    required String tag,
    required Function(String?) onWarning,
    required VoidCallback onEnabled,
    required VoidCallback onDisabled,
    required String notSupportedMessage,
  }) async {
    // ─ 1. فحص دعم البلوتوث ────────────────────────────────────────────────
    final isSupported = await FlutterBluePlus.isSupported;
    if (!isSupported) {
      debugPrint('❌ [بلوتوث$tag] الجهاز لا يدعم البلوتوث.');
      onWarning(notSupportedMessage);
      return null;
    }

    // ─ 2. محاولة تشغيل البلوتوث مرة واحدة عند البدء ────────────────────────
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (_) {}
    }

    // ─ 3. مراقبة الـ Adapter وإعادة التشغيل تلقائياً ─────────────────────
    return FlutterBluePlus.adapterState.listen((
      BluetoothAdapterState adapterState,
    ) {
      if (adapterState == BluetoothAdapterState.on) {
        debugPrint('✅ [بلوتوث$tag] تم تفعيل البلوتوث — إعادة التشغيل...');
        onWarning(null); // إلغاء التحذير
        onEnabled();
      } else {
        debugPrint('⚠️ [بلوتوث$tag] تم إغلاق البلوتوث!');
        onDisabled();
      }
    });
  }
}
