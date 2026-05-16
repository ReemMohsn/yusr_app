class ApiLink {
  // 1. Base URL
  static const String server = 'http://yusrapp.runasp.net/api';

  // 2. Auth (التوثيق)
  static const String login = '$server/Auth/LoginMobile';
  static const String forgotPassword = '$server/Auth/ForgotPassword';
  static const String sendCode = '$server/Auth/SendCode';
  static const String resetPassword = '$server/Auth/ResetPassword';
  static const String logout = '$server/Auth/Logout';

  // 3. Profile
  static const String getProfile = '$server/Profile/GetProfileMobile';

  static const String updateProfile = '$server/Profile/UpdateSaudiNumber';
  static String getGroupDetailsMobile(int groupId) =>
      '$server/Groups/GetGroupDetailsMobile/$groupId';
  static String getHajDetailsMobile(int userId) =>
      '$server/Groups/GetHajDetailsMobile/$userId';
  static String getGroupPilgrimsMobile(int groupId) =>
      '$server/Groups/GetGroupPilgrimsMobile/$groupId';
  static const String getMyGroupPilgrimsMobile =
      '$server/Groups/GetMyGroupPilgrims';
  // 4. Announcements & Notifications
  static const String syncData = '$server/Announcements/SyncData';
  static const String getNotifications =
      '$server/Announcements/GetNotifications';
  static const String getAnnouncements =
      '$server/Announcements/GetAnnouncements';
  static const String createAnnouncement =
      '$server/Announcements/CreateAndPublishAnnouncement';
  static const String deleteAnnouncement =
      '$server/Announcements/DeleteAnnouncement';

  static const String getTargetAudiences =
      '$server/Announcements/GetTargetAudiences';
  // Location
  static const String getActiveLocation = '$server/Location/GetActiveLocation';
  static const String getCampaignLocations =
      '$server/CampaignLocation/GetCampaignLocationsView';
  static const String addCampaignLocation =
      '$server/CampaignLocation/AddNewLocation';
  static const String updateLocationData =
      '$server/CampaignLocation/UpdateLocationData';
  static const String setActiveLocation =
      '$server/CampaignLocation/SetActiveLocation';
  static const String deleteLocation =
      '$server/CampaignLocation/DeleteLocation';

  // Campaign Management (مدير الحملة)
  static const String getCampaignInfoMobile = '$server/AboutCampaign/GetCampaignInfoMobile';
  static const String getCampaignGroupsMobile = '$server/AboutCampaign/GetCampaignGroupsMobile';
  static String getCampaignGroupDetailsMobile(int groupId) => '$server/AboutCampaign/GetCampaignGroupDetailsMobile/$groupId';
  
  // static const String getCampaignPilgrimsMobile = '$server/AboutCampaign/GetCampaignPilgrimsMobile';
  static String getCampaignPilgrimDetailsMobile(int userId) => '$server/AboutCampaign/GetCampaignPilgrimDetailsMobile/$userId';
  
  // static const String getCampaignSupervisorsMobile = '$server/AboutCampaign/GetCampaignSupervisorsMobile';
  // static String getCampaignSupervisorDetailsMobile(int userId) => '$server/AboutCampaign/GetCampaignSupervisorDetailsMobile/$userId';

  // be a leader
  static const String startTrackingSession = '$server/Monitoring/StartSession';
  static const String getPilgrims = '$server/Monitoring/GetSessionParticipants';
  static const String participantResponse =
      '$server/Monitoring/ParticipantResponse';
  static const String endTrackingSession = '$server/Monitoring/EndSession';

  // رابط خدمة المفتي الذكي (Hugging Face)
  static const String geminiChat = 'https://manar13-yusr-hajj-api.hf.space/ask';
  
  // 5. وظائف ديناميكية
  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }
}
