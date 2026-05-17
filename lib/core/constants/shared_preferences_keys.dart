// نغيرة حسب حقنا المشرروع
class SharedPreferencesKeys {
  static const String profile = 'profile';
  static const String isLoggedIn = 'is_logged_in';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String resetEmail = 'reset_email';
  static const String otpCode = 'otp_code';
  static const String currentSessionId = 'current_session_id';
  static const String sessionId = 'current_session_id';

  // 🔔 إشعارات كن قائد المحلية (تخزين القائمة JSON)
  static const String trackingNotifications = 'tracking_notifications_json';

  // دعوة جلسة معلقة (FCM وصل ولم يرد عليه الحاج)
  static const String pendingTrackingSessionId = 'pending_tracking_session_id';
  static const String pendingTrackingBody = 'pending_tracking_body';

  //عداد الطواف والسعي التلقائي
  static const String tawafSavedLap = 'tawaf_saved_lap';
  static const String tawafSavedType = 'tawaf_saved_type';
  static const String tawafSavedRunning = 'tawaf_saved_running';
}
