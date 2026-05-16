import 'package:intl/intl.dart';

/// ── نصوص التتبع القابلة للترجمة للاستخدام في الـ Controllers ──────────────
///
/// يُستخدَم هذا الملف بدلاً من hardcoded strings في الـ Riverpod controllers
/// التي لا تمتلك BuildContext. يعمل مع Intl.defaultLocale المُعيَّن تلقائياً
/// من قِبَل Flutter عند تغيير لغة التطبيق.
///
/// الاستخدام:
///   gpsWarning: TrackingStrings.gpsServiceDisabled,
class TrackingStrings {
  TrackingStrings._();

  // ── GPS Warnings ──────────────────────────────────────────────────────────

  static String get gpsServiceDisabled => Intl.message(
    'يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.',
    name: 'gpsServiceDisabledWarning',
  );

  static String get gpsPermissionDenied => Intl.message(
    'لا يمكن بدء التتبع بدون صلاحيات الموقع. يرجى تفعيلها من الإعدادات.',
    name: 'gpsPermissionDeniedWarning',
  );

  static String get gpsDisabled => Intl.message(
    'تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.',
    name: 'gpsDisabledWarning',
  );

  static String get gpsReenabled => Intl.message(
    'تم تفعيل الـ GPS، جاري التقاط الإشارة...',
    name: 'gpsReenabledWarning',
  );

  static String get gpsReenabledLeader => Intl.message(
    'الـ GPS مفعل، جاري تحديث الموقع (قد يكون في مكان مغلق)...',
    name: 'gpsReenabledLeaderWarning',
  );

  static String get gpsSystemError => Intl.message(
    'حدث خطأ في النظام. يرجى التأكد من الصلاحيات.',
    name: 'gpsSystemError',
  );

  // ── Session Errors ────────────────────────────────────────────────────────

  static String get leaderTimeout => Intl.message(
    'تم إيقاف التتبع لأن المشرف فقد الاتصال لأكثر من 30 دقيقة.',
    name: 'leaderTimeoutError',
  );

  static String get endSessionError => Intl.message(
    'حدث خطأ أثناء إنهاء الجلسة، يرجى المحاولة مرة أخرى.',
    name: 'endSessionError',
  );

  static String get unknownPilgrim => Intl.message(
    'أحد الحجاج',
    name: 'unknownPilgrim',
  );

  // ── Location Request ──────────────────────────────────────────────────────

  static String get locationRequestTitle => Intl.message(
    '📍 طلب مشاركة الموقع',
    name: 'locationRequestTitle',
  );

  // ── Pilgrim-side Notifications ────────────────────────────────────────────

  static String get pilgrimWarningChannelName => Intl.message(
    'تحذير الابتعاد',
    name: 'pilgrimWarningChannelName',
  );

  static String get pilgrimEmergencyChannelName => Intl.message(
    'تنبيه الابتعاد',
    name: 'pilgrimEmergencyChannelName',
  );

  static String get pilgrimWarningTitle => Intl.message(
    '🟡 تحذير: أنت تبتعد!',
    name: 'pilgrimWarningTitle',
  );

  static String get pilgrimWarningBody => Intl.message(
    'بدأت تبتعد عن مجموعتك. إسرع الخطى للمشرف.',
    name: 'pilgrimWarningBody',
  );

  static String get pilgrimEmergencyTitle => Intl.message(
    '🚨 إنذار خطر!',
    name: 'pilgrimEmergencyTitle',
  );

  static String get pilgrimEmergencyBody => Intl.message(
    'لقد ابتعدت عن المشرف خارج النطاق المسموح!',
    name: 'pilgrimEmergencyBody',
  );

  // ── Leader-side Notifications ─────────────────────────────────────────────

  static String get leaderWarningChannelName => Intl.message(
    'تحذيرات الحجاج المتأخرين',
    name: 'leaderWarningChannelName',
  );

  static String get leaderEmergencyChannelName => Intl.message(
    'طوارئ الحجاج',
    name: 'leaderEmergencyChannelName',
  );

  static String get leaderPilgrimWarningTitle => Intl.message(
    '🟡 تنبيه تأخر حاج',
    name: 'leaderPilgrimWarningTitle',
  );

  static String leaderPilgrimWarningBody(String name) => Intl.message(
    'الحاج "$name" بدأ يبتعد عن المجموعة.',
    name: 'leaderPilgrimWarningBody',
    args: [name],
    examples: {'name': 'أحمد'},
  );

  static String get leaderPilgrimEmergencyTitle => Intl.message(
    '🚨 خطر: حاج مفقود!',
    name: 'leaderPilgrimEmergencyTitle',
  );

  static String leaderPilgrimEmergencyBody(String name) => Intl.message(
    'الحاج "$name" تجاوز منطقة الأمان!',
    name: 'leaderPilgrimEmergencyBody',
    args: [name],
    examples: {'name': 'أحمد'},
  );
}
