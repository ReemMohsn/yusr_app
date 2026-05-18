import 'package:intl/intl.dart';

/// نصوص عداد الطواف والسعي القابلة للترجمة

class AutoCounterStrings {
  AutoCounterStrings._();

  // ── صلاحيات ───────────────────────────────────────────────────────────────

  static String get activityPermissionDenied => Intl.message(
    'يرجى منح صلاحية رصد النشاط الحركي من إعدادات الجهاز',
    name: 'activityPermissionDenied',
  );

  //  أخطاء الحساسات

  static String get stepSensorError =>
      Intl.message('تعذّر الوصول لعداد الخطوات', name: 'stepSensorError');

  static String get gyroscopeSensorError =>
      Intl.message('تعذّر الوصول للجيروسكوب', name: 'gyroscopeSensorError');

  //  إشعارات الخلفية

  static String get foregroundNotificationTitle => Intl.message(
    'يُسر - العداد التلقائي نشط',
    name: 'foregroundNotificationTitle',
  );

  static String get foregroundNotificationBody => Intl.message(
    'جاري حساب أشواطك بدقة في الخلفية',
    name: 'foregroundNotificationBody',
  );

  //  إشعارات اكتمال الأشواط

  static String get tawaf => Intl.message('الطواف', name: 'tawaf');

  static String get saee => Intl.message('السعي', name: 'saee');

  static String lapCompletedTitle(String type, int lap) => Intl.message(
    '✅ $type — الشوط $lap مكتمل',
    name: 'lapCompletedTitle',
    args: [type, lap],
    examples: {'type': 'الطواف', 'lap': 3},
  );

  static String lapsRemaining(int remaining) => Intl.message(
    'تبقّى $remaining أشواط',
    name: 'lapsRemaining',
    args: [remaining],
    examples: {'remaining': 4},
  );

  static String get allLapsCompleted =>
      Intl.message('اكتمل النسك بحمد الله!', name: 'allLapsCompleted');

  static String completionNotificationTitle(String type) => Intl.message(
    '🎉 تم إتمام $type',
    name: 'completionNotificationTitle',
    args: [type],
    examples: {'type': 'الطواف'},
  );

  static String get completionNotificationBody => Intl.message(
    'اكتملت الأشواط السبعة بحمد الله وفضله',
    name: 'completionNotificationBody',
  );

  //  اسم قناة الإشعارات

  static String get notificationChannelName => Intl.message(
    'عداد الطواف والسعي',
    name: 'tawafCounterNotificationChannelName',
  );
}
