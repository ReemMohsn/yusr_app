class ApiLink {
  // فقط أمثله لروابط الثلاثة الأساسية نقدر نعدلهاً بعد ذلك بما يتوافق مع مشاريعنا
  // Base
  static const String server = 'http://yusrapp.runasp.net/api';
  // static const String server = 'http://192.168.1.5:5161/api';

  // Auth
  static const String login = '$server/Auth/LoginMobile';
  static const String forgotPassword = '$server/Auth/ForgotPassword';
  static const String sendCode = '$server/Auth/SendCode';
  static const String resetPassword = '$server/Auth/ResetPassword';
  static const String logout = '$server/Auth/Logout';
  static const String syncData = '$server/Announcements/SyncData';
  static const String getNotifications =
      '$server/Announcements/GetNotifications';
  static const String getAnnouncements =
      '$server/Announcements/GetAnnouncements';
  static const String createAnnouncement =
      '$server/Announcements/CreateAndPublishAnnouncement';
  static const String deleteAnnouncement =
      '$server/Announcements/DeleteAnnouncement';
  // Location
  static const String getActiveLocation = '$server/Location/GetActiveLocation';

  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }
}
