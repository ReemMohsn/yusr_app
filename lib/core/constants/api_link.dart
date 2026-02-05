class ApiLink {
  // فقط أمثله لروابط الثلاثة الأساسية نقدر نعدلهاً بعد ذلك بما يتوافق مع مشاريعنا
  // Base
  static const String server = 'https://localhost:7122/api';

  // Auth
  static const String login = '$server/Auth/LoginMobile';
  static const String forgotPassword = '$server/Auth/ForgotPassword';
  static const String sendCode = '$server/Auth/SendCode';
  static const String resetPassword = '$server/Auth/ResetPassword';
  static const String logout = '$server/Auth/Logout';

  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }
}
