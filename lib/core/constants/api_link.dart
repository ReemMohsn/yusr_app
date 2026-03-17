class ApiLink {
  // 1. Base URL
  static const String server = 'http://yusrapp.runasp.net/api';

  // 2. Auth (التوثيق)
  static const String login = '$server/Auth/LoginMobile';
  static const String forgotPassword = '$server/Auth/ForgotPassword';
  static const String sendCode = '$server/Auth/SendCode';
  static const String resetPassword = '$server/Auth/ResetPassword';
  static const String logout = '$server/Auth/Logout';

  // 3. Announcements (ميزة الإعلانات - شغل ريم)
  static const String syncData = '$server/Announcements/SyncData';
  static const String getAnnouncements = '$server/Announcements/GetAnnouncements';
  static const String createAnnouncement = '$server/Announcements/CreateAndPublishAnnouncement';
  static const String deleteAnnouncement = '$server/Announcements/DeleteAnnouncement';

  // 4. Campaign Location (ميزة مواقع الحملة - شغلكِ)
  static const String getActiveLocation = '$server/Location/GetActiveLocation';
  static const String getCampaignLocations = '$server/CampaignLocation/GetCampaignLocationsView';
  static const String addCampaignLocation = '$server/CampaignLocation/AddNewLocation';
  static const String updateLocationData = '$server/CampaignLocation/UpdateLocationData';
  static const String setActiveLocation = '$server/CampaignLocation/SetActiveLocation';
  static const String deleteLocation = '$server/CampaignLocation/DeleteLocation';

  // 5. وظائف ديناميكية
  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }
}