class ApiLink {
  // فقط أمثله لروابط الثلاثة الأساسية نقدر نعدلهاً بعد ذلك بما يتوافق مع مشاريعنا
  // Base
  static const String server = 'https://smart-neighborhood-test.runasp.net/api';

  // Auth
  static const String login = '$server/auth/login';

  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }
}
