class ApiLink {
  // فقط أمثله لروابط الثلاثة الأساسية نقدر نعدلهاً بعد ذلك بما يتوافق مع مشاريعنا
  // Base
  static const String server = 'https://localhost:7122/api';

  // Auth
  static const String login = '$server/Auth/LoginMobile';
  static const String forgotPassword = '$server/Auth/ForgotPassword';

  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }
}
