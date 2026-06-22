import 'dart:async';
import 'dart:math';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';

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

  // 🆕 لتنعيم قراءات RSSI المتأرجحة
  final Map<int, List<double>> _bleDistanceHistory = {};
  static const int _bleSmoothingWindow = 4;
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
          navigatorKey.currentContext?.locale.bleClosedLeaderWarning ??
              'تم إغلاق البلوتوث. دقة تحديد الحجاج القريبين ستنخفض. يرجى تفعيله.',
        );
      },
      notSupportedMessage:
          navigatorKey.currentContext?.locale.bleNotSupportedLeaderWarning ??
          'جهازك لا يدعم البلوتوث.',
    );
  }

  Future<void> _startActualBleScanning() async {
    final bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      debugPrint(
        '⚠️ [رادار البلوتوث] GPS مغلق — سيُعاد المسح تلقائياً عند تفعيله.',
      );
      _onScanWarningChanged?.call(
        navigatorKey.currentContext?.locale.pleaseEnableGpsForBleWarning ??
            'يرجى تفعيل GPS لتشغيل رادار البلوتوث.',
      );
      return;
    }

    debugPrint('📡 [رادار البلوتوث] بدء مسح جديد مستمر...');
    _bleScanSub?.cancel();

    try {
      await FlutterBluePlus.startScan(continuousUpdates: true);
      debugPrint(
        '🔵 [BLE-TRACE] تم بدء المسح بنجاح — في انتظار النتائج...',
      ); // 🆕
    } on Exception catch (e) {
      debugPrint('❌ [رادار البلوتوث] فشل في بدء المسح: $e');
      _onScanWarningChanged?.call(
        navigatorKey.currentContext?.locale.bleScanFailedWarning ??
            'تعذّر بدء مسح البلوتوث. تأكد من تفعيل GPS والبلوتوث.',
      );
      return;
    }

    int devicesFound = 0;
    _bleScanSub = FlutterBluePlus.scanResults.listen((results) {
      if (results.length != devicesFound) {
        devicesFound = results.length;
        debugPrint(
          '🔵 [BLE-TRACE] أجهزة BLE مرصودة (أي نوع): $devicesFound جهاز.',
        ); // 🆕 (كان رسالة عامة، بقت BLE-TRACE)
      }
      for (ScanResult r in results) {
        int? extractedMinorId = _extractMinorIdFromBeacon(r);
        if (extractedMinorId != null) {
          int rssi = r.rssi;
          double estimatedDistance = pow(10, (-59 - rssi) / 20.0).toDouble();

          // 🆕 تنعيم القيمة بمتوسط آخر N قراءات
          final history = _bleDistanceHistory.putIfAbsent(
            extractedMinorId,
            () => [],
          );
          history.add(estimatedDistance);
          if (history.length > _bleSmoothingWindow) history.removeAt(0);
          final smoothedDistance =
              history.reduce((a, b) => a + b) / history.length;

          debugPrint(
            '🔵 [BLE-TRACE] استقبال | MinorId: $extractedMinorId | RSSI: $rssi dBm '
            '| خام: ${estimatedDistance.toStringAsFixed(2)}م | مُنعَّم: ${smoothedDistance.toStringAsFixed(2)}م',
          ); // 🆕

          bleDistances[extractedMinorId] = smoothedDistance;
          lastBleUpdates[extractedMinorId] = DateTime.now();
        }
      }
    });
  }

  int? _extractMinorIdFromBeacon(ScanResult result) {
    final manufacturerData = result.advertisementData.manufacturerData;

    // 1. Check for iBeacon (Apple = 76)
    if (manufacturerData.containsKey(76)) {
      final data = manufacturerData[76]!;
      if (data.length >= 23) {
        return (data[20] << 8) + data[21];
      }
    }

    // 2. Check for AltBeacon (Radius Networks = 280), default for Android beacon_broadcast
    if (manufacturerData.containsKey(280)) {
      final data = manufacturerData[280]!;
      // AltBeacon starts with 0xBE 0xAC, followed by 16-byte UUID, 2-byte Major, 2-byte Minor
      if (data.length >= 23 && data[0] == 0xBE && data[1] == 0xAC) {
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
    _bleDistanceHistory.clear();
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
          navigatorKey.currentContext?.locale.bleClosedPilgrimWarning ??
              'تم إغلاق البلوتوث. لن يتمكن المشرف من رصدك بدقة. يرجى تفعيله.',
        );
      },
      notSupportedMessage:
          navigatorKey.currentContext?.locale.bleNotSupportedPilgrimWarning ??
          'جهازك لا يدعم البلوتوث — لن يتمكن المشرف من رصدك بدقة.',
    );
  }

  void _actuallyStartBeaconBroadcast() {
    if (_currentPilgrimId == null) return;
    try {
      int numericId =
          (int.tryParse(_currentPilgrimId!) ?? _currentPilgrimId!.hashCode) %
          65535;
      _beaconBroadcast
          .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
          .setMajorId(1)
          .setMinorId(numericId)
          .start();
      debugPrint(
        '🟢 [BLE-TRACE] بدء البث | PilgrimId: $_currentPilgrimId | MinorId المُولَّد: $numericId',
      );
    } catch (e) {
      debugPrint('🔴 [BLE-TRACE] فشل البث | السبب: $e');
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
