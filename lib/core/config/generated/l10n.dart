// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Family/Relative Number`
  String get familyNumber {
    return Intl.message(
      'Family/Relative Number',
      name: 'familyNumber',
      desc: '',
      args: [],
    );
  }

  /// `About Campaign`
  String get aboutCampaign {
    return Intl.message(
      'About Campaign',
      name: 'aboutCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Campaign Dates`
  String get campaignDates {
    return Intl.message(
      'Campaign Dates',
      name: 'campaignDates',
      desc: '',
      args: [],
    );
  }

  /// `Campaign Start Date`
  String get campaignStartDate {
    return Intl.message(
      'Campaign Start Date',
      name: 'campaignStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Campaign Return Date`
  String get campaignReturnDate {
    return Intl.message(
      'Campaign Return Date',
      name: 'campaignReturnDate',
      desc: '',
      args: [],
    );
  }

  /// `General Information`
  String get generalInfo {
    return Intl.message(
      'General Information',
      name: 'generalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Total Pilgrims`
  String get totalPilgrims {
    return Intl.message(
      'Total Pilgrims',
      name: 'totalPilgrims',
      desc: '',
      args: [],
    );
  }

  /// `Total Groups`
  String get totalGroups {
    return Intl.message(
      'Total Groups',
      name: 'totalGroups',
      desc: '',
      args: [],
    );
  }

  /// `Total Supervisors`
  String get totalSupervisors {
    return Intl.message(
      'Total Supervisors',
      name: 'totalSupervisors',
      desc: '',
      args: [],
    );
  }

  /// `View Campaign Groups`
  String get viewCampaignGroups {
    return Intl.message(
      'View Campaign Groups',
      name: 'viewCampaignGroups',
      desc: '',
      args: [],
    );
  }

  /// `Campaign Groups`
  String get campaignGroups {
    return Intl.message(
      'Campaign Groups',
      name: 'campaignGroups',
      desc: '',
      args: [],
    );
  }

  /// `No groups currently`
  String get noGroupsCurrently {
    return Intl.message(
      'No groups currently',
      name: 'noGroupsCurrently',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor:`
  String get supervisor {
    return Intl.message('Supervisor:', name: 'supervisor', desc: '', args: []);
  }

  /// `Hijri Year:`
  String get hijriYear {
    return Intl.message('Hijri Year:', name: 'hijriYear', desc: '', args: []);
  }

  /// `Yusr`
  String get appName {
    return Intl.message('Yusr', name: 'appName', desc: '', args: []);
  }

  /// `The Smart Pilgrim Companion`
  String get appSlogan {
    return Intl.message(
      'The Smart Pilgrim Companion',
      name: 'appSlogan',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Manasek Counter`
  String get manasekCounter {
    return Intl.message(
      'Manasek Counter',
      name: 'manasekCounter',
      desc: '',
      args: [],
    );
  }

  /// `Smart Mufti`
  String get smartMufti {
    return Intl.message('Smart Mufti', name: 'smartMufti', desc: '', args: []);
  }

  /// `Take me back`
  String get returnMe {
    return Intl.message('Take me back', name: 'returnMe', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Prayer Times`
  String get prayerTimes {
    return Intl.message(
      'Prayer Times',
      name: 'prayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Campaign Location`
  String get campaignLocation {
    return Intl.message(
      'Campaign Location',
      name: 'campaignLocation',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Not found`
  String get notFound {
    return Intl.message('Not found', name: 'notFound', desc: '', args: []);
  }

  /// `Please login to view the campaign location`
  String get loginToViewCampaignLocation {
    return Intl.message(
      'Please login to view the campaign location',
      name: 'loginToViewCampaignLocation',
      desc: '',
      args: [],
    );
  }

  /// `Logged out and token revoked successfully`
  String get logoutSuccessMessage {
    return Intl.message(
      'Logged out and token revoked successfully',
      name: 'logoutSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Become a Leader`
  String get becomeALeader {
    return Intl.message(
      'Become a Leader',
      name: 'becomeALeader',
      desc: '',
      args: [],
    );
  }

  /// `Announcements`
  String get announcements {
    return Intl.message(
      'Announcements',
      name: 'announcements',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Group Information`
  String get groupInfo {
    return Intl.message(
      'Group Information',
      name: 'groupInfo',
      desc: '',
      args: [],
    );
  }

  /// `Hajj Rituals`
  String get hajjRituals {
    return Intl.message(
      'Hajj Rituals',
      name: 'hajjRituals',
      desc: '',
      args: [],
    );
  }

  /// `Journey of Faith`
  String get journeyOfFaith {
    return Intl.message(
      'Journey of Faith',
      name: 'journeyOfFaith',
      desc: '',
      args: [],
    );
  }

  /// `Labbayk Allahumma Labbayk`
  String get labbayk {
    return Intl.message(
      'Labbayk Allahumma Labbayk',
      name: 'labbayk',
      desc: '',
      args: [],
    );
  }

  /// `Hijri Date`
  String get hijriDate {
    return Intl.message('Hijri Date', name: 'hijriDate', desc: '', args: []);
  }

  /// `Fajr`
  String get fajr {
    return Intl.message('Fajr', name: 'fajr', desc: '', args: []);
  }

  /// `Dhuhr`
  String get dhuhr {
    return Intl.message('Dhuhr', name: 'dhuhr', desc: '', args: []);
  }

  /// `Asr`
  String get asr {
    return Intl.message('Asr', name: 'asr', desc: '', args: []);
  }

  /// `Maghrib`
  String get maghrib {
    return Intl.message('Maghrib', name: 'maghrib', desc: '', args: []);
  }

  /// `Isha`
  String get isha {
    return Intl.message('Isha', name: 'isha', desc: '', args: []);
  }

  /// `Step-by-step Rituals Preparation`
  String get ritualsPreparation {
    return Intl.message(
      'Step-by-step Rituals Preparation',
      name: 'ritualsPreparation',
      desc: '',
      args: [],
    );
  }

  /// `Start your journey to the destinations, and learn the correct steps of Hajj and Umrah with amazing details.`
  String get ritualsPreparationDesc {
    return Intl.message(
      'Start your journey to the destinations, and learn the correct steps of Hajj and Umrah with amazing details.',
      name: 'ritualsPreparationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Account Verification`
  String get accountVerification {
    return Intl.message(
      'Account Verification',
      name: 'accountVerification',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 5-digit verification code sent to you`
  String get enterVerificationCodeDescription {
    return Intl.message(
      'Enter the 5-digit verification code sent to you',
      name: 'enterVerificationCodeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verificationCodeLabel {
    return Intl.message(
      'Verification Code',
      name: 'verificationCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verifyCodeButton {
    return Intl.message(
      'Verify Code',
      name: 'verifyCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't worry, you can easily recover your account. Enter your email and we will send you a verification code.`
  String get forgotPasswordDescription {
    return Intl.message(
      'Don\'t worry, you can easily recover your account. Enter your email and we will send you a verification code.',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `A recovery link will be sent to your email.`
  String get recoveryLinkNote {
    return Intl.message(
      'A recovery link will be sent to your email.',
      name: 'recoveryLinkNote',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get sendVerificationCodeButton {
    return Intl.message(
      'Send Verification Code',
      name: 'sendVerificationCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Email or Passport Number`
  String get emailOrPassport {
    return Intl.message(
      'Email or Passport Number',
      name: 'emailOrPassport',
      desc: '',
      args: [],
    );
  }

  /// `Enter the required data`
  String get enterRequiredData {
    return Intl.message(
      'Enter the required data',
      name: 'enterRequiredData',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPasswordPrompt {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPasswordPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Set a new password`
  String get setNewPassword {
    return Intl.message(
      'Set a new password',
      name: 'setNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `The new password must be different from previous passwords`
  String get newPasswordDescription {
    return Intl.message(
      'The new password must be different from previous passwords',
      name: 'newPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordLabel {
    return Intl.message(
      'New Password',
      name: 'newPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get resetButton {
    return Intl.message('Reset', name: 'resetButton', desc: '', args: []);
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatchError {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatchError',
      desc: '',
      args: [],
    );
  }

  /// `Session expired or your data was modified. You are now browsing as a guest.`
  String get sessionExpiredGuest {
    return Intl.message(
      'Session expired or your data was modified. You are now browsing as a guest.',
      name: 'sessionExpiredGuest',
      desc: '',
      args: [],
    );
  }

  /// `Connection failed, please check your internet connection.`
  String get connectionFailed {
    return Intl.message(
      'Connection failed, please check your internet connection.',
      name: 'connectionFailed',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred, please try again.`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred, please try again.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `The server is currently not responding, please try again later.`
  String get serverNotResponding {
    return Intl.message(
      'The server is currently not responding, please try again later.',
      name: 'serverNotResponding',
      desc: '',
      args: [],
    );
  }

  /// `A server error occurred, please try again later.`
  String get serverError {
    return Intl.message(
      'A server error occurred, please try again later.',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `To ensure a safe journey and arrive peacefully, please login first`
  String get secureArrivalMessage {
    return Intl.message(
      'To ensure a safe journey and arrive peacefully, please login first',
      name: 'secureArrivalMessage',
      desc: '',
      args: [],
    );
  }

  /// `Location updated successfully`
  String get updateSuccess {
    return Intl.message(
      'Location updated successfully',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add Location`
  String get addLocation {
    return Intl.message(
      'Add Location',
      name: 'addLocation',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get currentLocation {
    return Intl.message(
      'Current Location',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Change Location`
  String get changeLocation {
    return Intl.message(
      'Change Location',
      name: 'changeLocation',
      desc: '',
      args: [],
    );
  }

  /// `Other Locations`
  String get otherLocations {
    return Intl.message(
      'Other Locations',
      name: 'otherLocations',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Choose Location Coordinates`
  String get chooseCoordinates {
    return Intl.message(
      'Choose Location Coordinates',
      name: 'chooseCoordinates',
      desc: '',
      args: [],
    );
  }

  /// `Save Location`
  String get saveLocation {
    return Intl.message(
      'Save Location',
      name: 'saveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location List`
  String get locationList {
    return Intl.message(
      'Location List',
      name: 'locationList',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Location Description`
  String get locationDescription {
    return Intl.message(
      'Location Description',
      name: 'locationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter a brief description for the location`
  String get enterLocationDescription {
    return Intl.message(
      'Enter a brief description for the location',
      name: 'enterLocationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Location Name`
  String get locationName {
    return Intl.message(
      'Location Name',
      name: 'locationName',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Please select a location first`
  String get selectLocationFirst {
    return Intl.message(
      'Please select a location first',
      name: 'selectLocationFirst',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching data`
  String get fetchDataError {
    return Intl.message(
      'Error fetching data',
      name: 'fetchDataError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Are you sure you want to delete this item permanently?`
  String get confirmDelete {
    return Intl.message(
      'Are you sure you want to delete this item permanently?',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Enter location name...`
  String get enterLocationName {
    return Intl.message(
      'Enter location name...',
      name: 'enterLocationName',
      desc: '',
      args: [],
    );
  }

  /// `Update Location`
  String get updateLocationTitle {
    return Intl.message(
      'Update Location',
      name: 'updateLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Location deleted successfully`
  String get deleteSuccess {
    return Intl.message(
      'Location deleted successfully',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Search for notifications...`
  String get notificationSearch {
    return Intl.message(
      'Search for notifications...',
      name: 'notificationSearch',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while fetching notifications:`
  String get errorFetchingNotifications {
    return Intl.message(
      'An error occurred while fetching notifications:',
      name: 'errorFetchingNotifications',
      desc: '',
      args: [],
    );
  }

  /// `There are currently no notifications`
  String get noNotificationsCurrently {
    return Intl.message(
      'There are currently no notifications',
      name: 'noNotificationsCurrently',
      desc: '',
      args: [],
    );
  }

  /// `Message Content`
  String get messageContent {
    return Intl.message(
      'Message Content',
      name: 'messageContent',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get detiles {
    return Intl.message('Details', name: 'detiles', desc: '', args: []);
  }

  /// `Search for announcement...`
  String get announcementSearch {
    return Intl.message(
      'Search for announcement...',
      name: 'announcementSearch',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while fetching announcements:`
  String get errorFetchingAnnouncements {
    return Intl.message(
      'An error occurred while fetching announcements:',
      name: 'errorFetchingAnnouncements',
      desc: '',
      args: [],
    );
  }

  /// `There are currently no announcements`
  String get noAnnouncementsCurrently {
    return Intl.message(
      'There are currently no announcements',
      name: 'noAnnouncementsCurrently',
      desc: '',
      args: [],
    );
  }

  /// `Add Announcement`
  String get addAnnouncement {
    return Intl.message(
      'Add Announcement',
      name: 'addAnnouncement',
      desc: '',
      args: [],
    );
  }

  /// `Announcement Title`
  String get announcementTitle {
    return Intl.message(
      'Announcement Title',
      name: 'announcementTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter announcement title...`
  String get enterAnnouncementTitle {
    return Intl.message(
      'Enter announcement title...',
      name: 'enterAnnouncementTitle',
      desc: '',
      args: [],
    );
  }

  /// `Announcement Content`
  String get announcementContent {
    return Intl.message(
      'Announcement Content',
      name: 'announcementContent',
      desc: '',
      args: [],
    );
  }

  /// `Write announcement content here...`
  String get writeAnnouncementContentHere {
    return Intl.message(
      'Write announcement content here...',
      name: 'writeAnnouncementContentHere',
      desc: '',
      args: [],
    );
  }

  /// `Target Audience`
  String get targetAudience {
    return Intl.message(
      'Target Audience',
      name: 'targetAudience',
      desc: '',
      args: [],
    );
  }

  /// `Publish Announcement`
  String get publishAnnouncement {
    return Intl.message(
      'Publish Announcement',
      name: 'publishAnnouncement',
      desc: '',
      args: [],
    );
  }

  /// `No matching search results found`
  String get noMatchingSearchResults {
    return Intl.message(
      'No matching search results found',
      name: 'noMatchingSearchResults',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Sending`
  String get confirmSend {
    return Intl.message(
      'Confirm Sending',
      name: 'confirmSend',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to send this announcement?`
  String get confirmSendAnnouncementQuestion {
    return Intl.message(
      'Are you sure you want to send this announcement?',
      name: 'confirmSendAnnouncementQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get titleLabel {
    return Intl.message('Title', name: 'titleLabel', desc: '', args: []);
  }

  /// `Content`
  String get contentLabel {
    return Intl.message('Content', name: 'contentLabel', desc: '', args: []);
  }

  /// `Once sent, the announcement will reach all users in the selected category and this action cannot be undone.`
  String get sendAnnouncementWarning {
    return Intl.message(
      'Once sent, the announcement will reach all users in the selected category and this action cannot be undone.',
      name: 'sendAnnouncementWarning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this announcement? This action cannot be undone.`
  String get confirmDeleteAnnouncementMessage {
    return Intl.message(
      'Are you sure you want to delete this announcement? This action cannot be undone.',
      name: 'confirmDeleteAnnouncementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Fetching campaign location...`
  String get messageFetchingCampLocationmessage {
    return Intl.message(
      'Fetching campaign location...',
      name: 'messageFetchingCampLocationmessage',
      desc: '',
      args: [],
    );
  }

  /// `km`
  String get km {
    return Intl.message('km', name: 'km', desc: '', args: []);
  }

  /// `Important Announcement`
  String get importantAnnouncement {
    return Intl.message(
      'Important Announcement',
      name: 'importantAnnouncement',
      desc: '',
      args: [],
    );
  }

  /// `Administration`
  String get administration {
    return Intl.message(
      'Administration',
      name: 'administration',
      desc: '',
      args: [],
    );
  }

  /// `New Notification`
  String get newNotification {
    return Intl.message(
      'New Notification',
      name: 'newNotification',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Start Session`
  String get startSession {
    return Intl.message(
      'Start Session',
      name: 'startSession',
      desc: '',
      args: [],
    );
  }

  /// `Show Map`
  String get showMap {
    return Intl.message('Show Map', name: 'showMap', desc: '', args: []);
  }

  /// `An error occurred: `
  String get errorOccurred {
    return Intl.message(
      'An error occurred: ',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Not Active`
  String get notActive {
    return Intl.message('Not Active', name: 'notActive', desc: '', args: []);
  }

  /// `Pilgrims List`
  String get pilgrimsListTitle {
    return Intl.message(
      'Pilgrims List',
      name: 'pilgrimsListTitle',
      desc: '',
      args: [],
    );
  }

  /// `No pilgrims associated with this session.`
  String get noPilgrimsInSession {
    return Intl.message(
      'No pilgrims associated with this session.',
      name: 'noPilgrimsInSession',
      desc: '',
      args: [],
    );
  }

  /// `You are here`
  String get youAreHere {
    return Intl.message('You are here', name: 'youAreHere', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Hajj Types`
  String get instructions {
    return Intl.message('Hajj Types', name: 'instructions', desc: '', args: []);
  }

  /// `Hajj Rituals of`
  String get hajjActionsTitle {
    return Intl.message(
      'Hajj Rituals of',
      name: 'hajjActionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival and Makkah Activities","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention and Covenant","items":["Anyone intending Hajj or Umrah should consciously seek closeness to Allah Almighty and purify their intention for this great obligation.","Hajj is an opportunity for sincere repentance, renewing one's covenant with Allah, and abandoning all sins.","Ensure all your wealth funding the Hajj is pure and Halal."],"type":"text"}]}]}]`
  String get hajjIfradData {
    return Intl.message(
      '[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival and Makkah Activities","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention and Covenant","items":["Anyone intending Hajj or Umrah should consciously seek closeness to Allah Almighty and purify their intention for this great obligation.","Hajj is an opportunity for sincere repentance, renewing one\'s covenant with Allah, and abandoning all sins.","Ensure all your wealth funding the Hajj is pure and Halal."],"type":"text"}]}]}]',
      name: 'hajjIfradData',
      desc: '',
      args: [],
    );
  }

  /// `[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival for the Qarin","actions":[{"name":"Intention for Qiran","emoji":"🤲","sections":[{"title":"Combining the Intention","items":["He makes the intention saying: Labbayk Allahumma Umratan wa Hajjan.","The Qarin does not exit Ihram like the Mufrid."],"type":"text"}]}]}]`
  String get hajjQiranData {
    return Intl.message(
      '[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival for the Qarin","actions":[{"name":"Intention for Qiran","emoji":"🤲","sections":[{"title":"Combining the Intention","items":["He makes the intention saying: Labbayk Allahumma Umratan wa Hajjan.","The Qarin does not exit Ihram like the Mufrid."],"type":"text"}]}]}]',
      name: 'hajjQiranData',
      desc: '',
      args: [],
    );
  }

  /// `[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Performing Umrah for Tamattu","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention for Tamattu","items":["At the Miqat, the pilgrim intends only Umrah."],"type":"text"}]}]}]`
  String get hajjTamattuData {
    return Intl.message(
      '[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Performing Umrah for Tamattu","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention for Tamattu","items":["At the Miqat, the pilgrim intends only Umrah."],"type":"text"}]}]}]',
      name: 'hajjTamattuData',
      desc: '',
      args: [],
    );
  }

  /// `[{"title":"Ifrad","subtitle":"Ihram for Hajj only","description":"Entering Ihram for Hajj alone from the Miqat, saying: Labbayk Hajjan"},{"title":"Qiran","subtitle":"Ihram for Hajj and Umrah together","description":"Entering Ihram for both Umrah and Hajj together, saying: Labbayk Umratan wa Hajjan"},{"title":"Tamattu","subtitle":"Umrah then Hajj in the months of Hajj","description":"Entering Ihram for Umrah, exiting it fully, then entering Ihram again for Hajj"}]`
  String get instructionsListData {
    return Intl.message(
      '[{"title":"Ifrad","subtitle":"Ihram for Hajj only","description":"Entering Ihram for Hajj alone from the Miqat, saying: Labbayk Hajjan"},{"title":"Qiran","subtitle":"Ihram for Hajj and Umrah together","description":"Entering Ihram for both Umrah and Hajj together, saying: Labbayk Umratan wa Hajjan"},{"title":"Tamattu","subtitle":"Umrah then Hajj in the months of Hajj","description":"Entering Ihram for Umrah, exiting it fully, then entering Ihram again for Hajj"}]',
      name: 'instructionsListData',
      desc: '',
      args: [],
    );
  }

  /// `Tawaf`
  String get tawaf {
    return Intl.message('Tawaf', name: 'tawaf', desc: '', args: []);
  }

  /// `Saei`
  String get saei {
    return Intl.message('Saei', name: 'saei', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Click to start counting`
  String get clickToStart {
    return Intl.message(
      'Click to start counting',
      name: 'clickToStart',
      desc: '',
      args: [],
    );
  }

  /// `Current Stroke`
  String get currentStroke {
    return Intl.message(
      'Current Stroke',
      name: 'currentStroke',
      desc: '',
      args: [],
    );
  }

  /// `Auto Update`
  String get autoUpdate {
    return Intl.message('Auto Update', name: 'autoUpdate', desc: '', args: []);
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Strokes`
  String get strokes {
    return Intl.message('Strokes', name: 'strokes', desc: '', args: []);
  }

  /// `of`
  String get ofWord {
    return Intl.message('of', name: 'ofWord', desc: '', args: []);
  }

  /// `Strokes are updated automatically based on your location from the Black Stone and your movement around the Kaaba.`
  String get tawafDescription {
    return Intl.message(
      'Strokes are updated automatically based on your location from the Black Stone and your movement around the Kaaba.',
      name: 'tawafDescription',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `🎉 Congratulations!`
  String get congratulations {
    return Intl.message(
      '🎉 Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully completed all rounds`
  String get all_rounds_completed {
    return Intl.message(
      'You have successfully completed all rounds',
      name: 'all_rounds_completed',
      desc: '',
      args: [],
    );
  }

  /// `May Allah accept`
  String get tawaf_saei_success_msg {
    return Intl.message(
      'May Allah accept',
      name: 'tawaf_saei_success_msg',
      desc: '',
      args: [],
    );
  }

  /// `Ask for a Fatwa`
  String get askForFatwa {
    return Intl.message(
      'Ask for a Fatwa',
      name: 'askForFatwa',
      desc: '',
      args: [],
    );
  }

  /// `Your smart assistant for Hajj questions`
  String get smartMuftiHelper {
    return Intl.message(
      'Your smart assistant for Hajj questions',
      name: 'smartMuftiHelper',
      desc: '',
      args: [],
    );
  }

  /// `Your Question`
  String get yourQuestion {
    return Intl.message(
      'Your Question',
      name: 'yourQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Example: What is the ruling on forgetting Tawaf al-Ifadah?`
  String get questionExample {
    return Intl.message(
      'Example: What is the ruling on forgetting Tawaf al-Ifadah?',
      name: 'questionExample',
      desc: '',
      args: [],
    );
  }

  /// `Get Answer`
  String get getAnswer {
    return Intl.message('Get Answer', name: 'getAnswer', desc: '', args: []);
  }

  /// `Sharia Answer`
  String get shariaAnswer {
    return Intl.message(
      'Sharia Answer',
      name: 'shariaAnswer',
      desc: '',
      args: [],
    );
  }

  /// `The detailed response will appear here after typing your question and clicking search...`
  String get shariaAnswerPlaceholder {
    return Intl.message(
      'The detailed response will appear here after typing your question and clicking search...',
      name: 'shariaAnswerPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Write your fatwa question here...`
  String get writeYourFatwaQuestion {
    return Intl.message(
      'Write your fatwa question here...',
      name: 'writeYourFatwaQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Send Question`
  String get sendQuestion {
    return Intl.message(
      'Send Question',
      name: 'sendQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for your question to be answered by AI...`
  String get waitingForYourQuestion {
    return Intl.message(
      'Waiting for your question to be answered by AI...',
      name: 'waitingForYourQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Please enter your question first`
  String get fieldRequired {
    return Intl.message(
      'Please enter your question first',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message('Profile', name: 'profileTitle', desc: '', args: []);
  }

  /// `An error occurred while loading data`
  String get errorLoadingData {
    return Intl.message(
      'An error occurred while loading data',
      name: 'errorLoadingData',
      desc: '',
      args: [],
    );
  }

  /// `Personal Data`
  String get personalData {
    return Intl.message(
      'Personal Data',
      name: 'personalData',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Health Status`
  String get healthStatus {
    return Intl.message(
      'Health Status',
      name: 'healthStatus',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inactive {
    return Intl.message('Inactive', name: 'inactive', desc: '', args: []);
  }

  /// `Residential Location`
  String get residentialLocation {
    return Intl.message(
      'Residential Location',
      name: 'residentialLocation',
      desc: '',
      args: [],
    );
  }

  /// `Contact Data`
  String get contactData {
    return Intl.message(
      'Contact Data',
      name: 'contactData',
      desc: '',
      args: [],
    );
  }

  /// `Saudi Mobile Number`
  String get saudiMobileNumber {
    return Intl.message(
      'Saudi Mobile Number',
      name: 'saudiMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Yemeni Mobile Number`
  String get yemeniMobileNumber {
    return Intl.message(
      'Yemeni Mobile Number',
      name: 'yemeniMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp Number`
  String get whatsappNumber {
    return Intl.message(
      'WhatsApp Number',
      name: 'whatsappNumber',
      desc: '',
      args: [],
    );
  }

  /// `Relative Contact`
  String get relativeContact {
    return Intl.message(
      'Relative Contact',
      name: 'relativeContact',
      desc: '',
      args: [],
    );
  }

  /// `Copied successfully`
  String get copiedSuccessfully {
    return Intl.message(
      'Copied successfully',
      name: 'copiedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Sharing...`
  String get sharing {
    return Intl.message('Sharing...', name: 'sharing', desc: '', args: []);
  }

  /// `User`
  String get userRole {
    return Intl.message('User', name: 'userRole', desc: '', args: []);
  }

  /// `Not Added`
  String get notAdded {
    return Intl.message('Not Added', name: 'notAdded', desc: '', args: []);
  }

  /// `Add Saudi Number`
  String get addSaudiNumberAction {
    return Intl.message(
      'Add Saudi Number',
      name: 'addSaudiNumberAction',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copiedText {
    return Intl.message('Copied', name: 'copiedText', desc: '', args: []);
  }

  /// `Add Saudi Phone Number`
  String get addSaudiNumber {
    return Intl.message(
      'Add Saudi Phone Number',
      name: 'addSaudiNumber',
      desc: '',
      args: [],
    );
  }

  /// `Edit Saudi Phone Number`
  String get editSaudiNumber {
    return Intl.message(
      'Edit Saudi Phone Number',
      name: 'editSaudiNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number`
  String get saudiPhoneRequired {
    return Intl.message(
      'Please enter phone number',
      name: 'saudiPhoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Number must start with 5`
  String get saudiPhoneMustStartWith5 {
    return Intl.message(
      'Number must start with 5',
      name: 'saudiPhoneMustStartWith5',
      desc: '',
      args: [],
    );
  }

  /// `Number must be exactly 9 digits`
  String get saudiPhoneMustBe9Digits {
    return Intl.message(
      'Number must be exactly 9 digits',
      name: 'saudiPhoneMustBe9Digits',
      desc: '',
      args: [],
    );
  }

  /// `Importance of Saudi Number`
  String get saudiPhoneImportance {
    return Intl.message(
      'Importance of Saudi Number',
      name: 'saudiPhoneImportance',
      desc: '',
      args: [],
    );
  }

  /// `A local Saudi phone number is necessary to contact you inside the Kingdom during your Hajj journey. Please ensure the number is correct.`
  String get saudiPhoneImportanceDesc {
    return Intl.message(
      'A local Saudi phone number is necessary to contact you inside the Kingdom during your Hajj journey. Please ensure the number is correct.',
      name: 'saudiPhoneImportanceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Local number for contact in Saudi Arabia 🇸🇦`
  String get localSADialTitle {
    return Intl.message(
      'Local number for contact in Saudi Arabia 🇸🇦',
      name: 'localSADialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save Number`
  String get saveNumber {
    return Intl.message('Save Number', name: 'saveNumber', desc: '', args: []);
  }

  /// `Important Notes`
  String get importantNotesTitle {
    return Intl.message(
      'Important Notes',
      name: 'importantNotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Example: 501234567`
  String get saudiPhoneHint {
    return Intl.message(
      'Example: 501234567',
      name: 'saudiPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Ensure the number starts with 5`
  String get note1 {
    return Intl.message(
      'Ensure the number starts with 5',
      name: 'note1',
      desc: '',
      args: [],
    );
  }

  /// `The number must consist of 9 digits`
  String get note2 {
    return Intl.message(
      'The number must consist of 9 digits',
      name: 'note2',
      desc: '',
      args: [],
    );
  }

  /// `Verify the number as it will be used to contact you`
  String get note3 {
    return Intl.message(
      'Verify the number as it will be used to contact you',
      name: 'note3',
      desc: '',
      args: [],
    );
  }

  /// `You can modify the number at any time`
  String get note4 {
    return Intl.message(
      'You can modify the number at any time',
      name: 'note4',
      desc: '',
      args: [],
    );
  }

  /// `Add Saudi Phone Number`
  String get addNumberTitle {
    return Intl.message(
      'Add Saudi Phone Number',
      name: 'addNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Saudi Phone Number`
  String get editNumberTitle {
    return Intl.message(
      'Edit Saudi Phone Number',
      name: 'editNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Number`
  String get addNumberBtn {
    return Intl.message('Add Number', name: 'addNumberBtn', desc: '', args: []);
  }

  /// `Save Number`
  String get saveNumberBtn {
    return Intl.message(
      'Save Number',
      name: 'saveNumberBtn',
      desc: '',
      args: [],
    );
  }

  /// `Edit Number`
  String get editNumber {
    return Intl.message('Edit Number', name: 'editNumber', desc: '', args: []);
  }

  /// `Number added successfully`
  String get addedSaudiNumberSuccess {
    return Intl.message(
      'Number added successfully',
      name: 'addedSaudiNumberSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Number updated successfully`
  String get editedSaudiNumberSuccess {
    return Intl.message(
      'Number updated successfully',
      name: 'editedSaudiNumberSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Group Information`
  String get groupInfoSectionTitle {
    return Intl.message(
      'Group Information',
      name: 'groupInfoSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Group Name`
  String get groupName {
    return Intl.message('Group Name', name: 'groupName', desc: '', args: []);
  }

  /// `Pilgrims Count`
  String get pilgrimsCount {
    return Intl.message(
      'Pilgrims Count',
      name: 'pilgrimsCount',
      desc: '',
      args: [],
    );
  }

  /// `Arrival Date`
  String get arrivalDate {
    return Intl.message(
      'Arrival Date',
      name: 'arrivalDate',
      desc: '',
      args: [],
    );
  }

  /// `Departure Date`
  String get departureDate {
    return Intl.message(
      'Departure Date',
      name: 'departureDate',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor Information`
  String get supervisorInfo {
    return Intl.message(
      'Supervisor Information',
      name: 'supervisorInfo',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor Name`
  String get supervisorName {
    return Intl.message(
      'Supervisor Name',
      name: 'supervisorName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `No Group Assigned Yet`
  String get groupNotAssignedTitle {
    return Intl.message(
      'No Group Assigned Yet',
      name: 'groupNotAssignedTitle',
      desc: '',
      args: [],
    );
  }

  /// `You haven't been assigned to a group yet. Please contact the campaign manager.`
  String get groupNotAssignedBody {
    return Intl.message(
      'You haven\'t been assigned to a group yet. Please contact the campaign manager.',
      name: 'groupNotAssignedBody',
      desc: '',
      args: [],
    );
  }

  /// `Group Details`
  String get supervisorGroupDetails {
    return Intl.message(
      'Group Details',
      name: 'supervisorGroupDetails',
      desc: '',
      args: [],
    );
  }

  /// `members`
  String get members {
    return Intl.message('members', name: 'members', desc: '', args: []);
  }

  /// `Search pilgrim...`
  String get searchPilgrim {
    return Intl.message(
      'Search pilgrim...',
      name: 'searchPilgrim',
      desc: '',
      args: [],
    );
  }

  /// `No pilgrims found`
  String get noPilgrimsFound {
    return Intl.message(
      'No pilgrims found',
      name: 'noPilgrimsFound',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Pilgrim Details`
  String get pilgrimDetails {
    return Intl.message(
      'Pilgrim Details',
      name: 'pilgrimDetails',
      desc: '',
      args: [],
    );
  }

  /// `Error loading pilgrim data`
  String get errorLoadingPilgrimData {
    return Intl.message(
      'Error loading pilgrim data',
      name: 'errorLoadingPilgrimData',
      desc: '',
      args: [],
    );
  }

  /// `Passport Number`
  String get passportNumber {
    return Intl.message(
      'Passport Number',
      name: 'passportNumber',
      desc: '',
      args: [],
    );
  }

  /// `Stable`
  String get healthStable {
    return Intl.message('Stable', name: 'healthStable', desc: '', args: []);
  }

  /// `Steps`
  String get steps {
    return Intl.message('Steps', name: 'steps', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Walking`
  String get walking {
    return Intl.message('Walking', name: 'walking', desc: '', args: []);
  }

  /// `Stopped`
  String get stopped {
    return Intl.message('Stopped', name: 'stopped', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Yusr App`
  String get onboarding_title_1 {
    return Intl.message(
      'Yusr App',
      name: 'onboarding_title_1',
      desc: '',
      args: [],
    );
  }

  /// `Your trusted digital companion to guide you step-by-step through your Hajj journey.`
  String get onboarding_desc_1 {
    return Intl.message(
      'Your trusted digital companion to guide you step-by-step through your Hajj journey.',
      name: 'onboarding_desc_1',
      desc: '',
      args: [],
    );
  }

  /// `Smart Guidance & Tracking`
  String get onboarding_title_2 {
    return Intl.message(
      'Smart Guidance & Tracking',
      name: 'onboarding_title_2',
      desc: '',
      args: [],
    );
  }

  /// `Instant guidance back to your tent and camp, with live field tracking by your supervisor for maximum safety.`
  String get onboarding_desc_2 {
    return Intl.message(
      'Instant guidance back to your tent and camp, with live field tracking by your supervisor for maximum safety.',
      name: 'onboarding_desc_2',
      desc: '',
      args: [],
    );
  }

  /// `Smart Tawaf Counter`
  String get onboarding_title_3 {
    return Intl.message(
      'Smart Tawaf Counter',
      name: 'onboarding_title_3',
      desc: '',
      args: [],
    );
  }

  /// `Automatically tracks your Tawaf and Sa'ee laps, letting you focus fully on your prayers.`
  String get onboarding_desc_3 {
    return Intl.message(
      'Automatically tracks your Tawaf and Sa\'ee laps, letting you focus fully on your prayers.',
      name: 'onboarding_desc_3',
      desc: '',
      args: [],
    );
  }

  /// `Hajj Guide`
  String get onboarding_title_4 {
    return Intl.message(
      'Hajj Guide',
      name: 'onboarding_title_4',
      desc: '',
      args: [],
    );
  }

  /// `Day-by-day Fiqh instructions, clearly covering rituals, restrictions, and recommended Duas.`
  String get onboarding_desc_4 {
    return Intl.message(
      'Day-by-day Fiqh instructions, clearly covering rituals, restrictions, and recommended Duas.',
      name: 'onboarding_desc_4',
      desc: '',
      args: [],
    );
  }

  /// `AI Mufti for Hajj Rulings`
  String get onboarding_title_5 {
    return Intl.message(
      'AI Mufti for Hajj Rulings',
      name: 'onboarding_title_5',
      desc: '',
      args: [],
    );
  }

  /// `Ask your Hajj-related questions and get instant, reliable scholarly answers anytime.`
  String get onboarding_desc_5 {
    return Intl.message(
      'Ask your Hajj-related questions and get instant, reliable scholarly answers anytime.',
      name: 'onboarding_desc_5',
      desc: '',
      args: [],
    );
  }

  /// `Notifications & Alerts`
  String get onboarding_title_6 {
    return Intl.message(
      'Notifications & Alerts',
      name: 'onboarding_title_6',
      desc: '',
      args: [],
    );
  }

  /// `Receive instant updates and urgent announcements directly from your supervisor or manager.`
  String get onboarding_desc_6 {
    return Intl.message(
      'Receive instant updates and urgent announcements directly from your supervisor or manager.',
      name: 'onboarding_desc_6',
      desc: '',
      args: [],
    );
  }

  /// `Session ended successfully`
  String get sessionEndedSuccessfully {
    return Intl.message(
      'Session ended successfully',
      name: 'sessionEndedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Mute alarm temporarily`
  String get muteAlarmTemporarily {
    return Intl.message(
      'Mute alarm temporarily',
      name: 'muteAlarmTemporarily',
      desc: '',
      args: [],
    );
  }

  /// `🔇 Sound muted. It will return automatically when pilgrims are safe.`
  String get alarmMutedTemporarilyMsg {
    return Intl.message(
      '🔇 Sound muted. It will return automatically when pilgrims are safe.',
      name: 'alarmMutedTemporarilyMsg',
      desc: '',
      args: [],
    );
  }

  /// `Locating, please wait...`
  String get locatingPleaseWait {
    return Intl.message(
      'Locating, please wait...',
      name: 'locatingPleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `End session officially`
  String get endSessionOfficially {
    return Intl.message(
      'End session officially',
      name: 'endSessionOfficially',
      desc: '',
      args: [],
    );
  }

  /// `End Session`
  String get endSession {
    return Intl.message('End Session', name: 'endSession', desc: '', args: []);
  }

  /// `Are you sure you want to end tracking? The session will be stopped for all pilgrims.`
  String get confirmEndSessionMsg {
    return Intl.message(
      'Are you sure you want to end tracking? The session will be stopped for all pilgrims.',
      name: 'confirmEndSessionMsg',
      desc: '',
      args: [],
    );
  }

  /// `Confirm End`
  String get confirmEnd {
    return Intl.message('Confirm End', name: 'confirmEnd', desc: '', args: []);
  }

  /// `Inside safe zone 🟢`
  String get inSafeZone {
    return Intl.message(
      'Inside safe zone 🟢',
      name: 'inSafeZone',
      desc: '',
      args: [],
    );
  }

  /// `On the borders 🟠`
  String get onBorders {
    return Intl.message(
      'On the borders 🟠',
      name: 'onBorders',
      desc: '',
      args: [],
    );
  }

  /// `Out of zone ⚠️ Danger`
  String get outOfZoneDanger {
    return Intl.message(
      'Out of zone ⚠️ Danger',
      name: 'outOfZoneDanger',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connectedMap {
    return Intl.message('Connected', name: 'connectedMap', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnectedMap {
    return Intl.message(
      'Disconnected',
      name: 'disconnectedMap',
      desc: '',
      args: [],
    );
  }

  /// `Distance from leader`
  String get distanceFromLeader {
    return Intl.message(
      'Distance from leader',
      name: 'distanceFromLeader',
      desc: '',
      args: [],
    );
  }

  /// `meter`
  String get meterWord {
    return Intl.message('meter', name: 'meterWord', desc: '', args: []);
  }

  /// `Last actual move`
  String get lastActualMove {
    return Intl.message(
      'Last actual move',
      name: 'lastActualMove',
      desc: '',
      args: [],
    );
  }

  /// `Last phone signal`
  String get lastPhoneSignal {
    return Intl.message(
      'Last phone signal',
      name: 'lastPhoneSignal',
      desc: '',
      args: [],
    );
  }

  /// `Searching for your location...`
  String get searchingForLocation {
    return Intl.message(
      'Searching for your location...',
      name: 'searchingForLocation',
      desc: '',
      args: [],
    );
  }

  /// `No Internet`
  String get noInternet {
    return Intl.message('No Internet', name: 'noInternet', desc: '', args: []);
  }

  /// `No pilgrims`
  String get noPilgrims {
    return Intl.message('No pilgrims', name: 'noPilgrims', desc: '', args: []);
  }

  /// `Inside zone`
  String get insideZone {
    return Intl.message('Inside zone', name: 'insideZone', desc: '', args: []);
  }

  /// `On borders`
  String get onBordersOnly {
    return Intl.message(
      'On borders',
      name: 'onBordersOnly',
      desc: '',
      args: [],
    );
  }

  /// `Out of zone`
  String get outOfZone {
    return Intl.message('Out of zone', name: 'outOfZone', desc: '', args: []);
  }

  /// `Stop Tracking`
  String get stopTracking {
    return Intl.message(
      'Stop Tracking',
      name: 'stopTracking',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to stop tracking and leave the session? The supervisor will be notified.`
  String get stopTrackingConfirmMsg {
    return Intl.message(
      'Are you sure you want to stop tracking and leave the session? The supervisor will be notified.',
      name: 'stopTrackingConfirmMsg',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Stop`
  String get yesStop {
    return Intl.message('Yes, Stop', name: 'yesStop', desc: '', args: []);
  }

  /// `🔇 Sound muted. It will return automatically when you return to safety.`
  String get alarmMutedPilgrimMsg {
    return Intl.message(
      '🔇 Sound muted. It will return automatically when you return to safety.',
      name: 'alarmMutedPilgrimMsg',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get youWord {
    return Intl.message('You', name: 'youWord', desc: '', args: []);
  }

  /// `Warning zone (20m)`
  String get warningZone20m {
    return Intl.message(
      'Warning zone (20m)',
      name: 'warningZone20m',
      desc: '',
      args: [],
    );
  }

  /// `Danger zone (30m)`
  String get dangerZone30m {
    return Intl.message(
      'Danger zone (30m)',
      name: 'dangerZone30m',
      desc: '',
      args: [],
    );
  }

  /// `Please enable the GPS (Location) service on your device.`
  String get gpsServiceDisabledWarning {
    return Intl.message(
      'Please enable the GPS (Location) service on your device.',
      name: 'gpsServiceDisabledWarning',
      desc: '',
      args: [],
    );
  }

  /// `Cannot start tracking without location permissions. Please enable them from Settings.`
  String get gpsPermissionDeniedWarning {
    return Intl.message(
      'Cannot start tracking without location permissions. Please enable them from Settings.',
      name: 'gpsPermissionDeniedWarning',
      desc: '',
      args: [],
    );
  }

  /// `Location service (GPS) has been turned off. Please enable it.`
  String get gpsDisabledWarning {
    return Intl.message(
      'Location service (GPS) has been turned off. Please enable it.',
      name: 'gpsDisabledWarning',
      desc: '',
      args: [],
    );
  }

  /// `GPS has been enabled, acquiring signal...`
  String get gpsReenabledWarning {
    return Intl.message(
      'GPS has been enabled, acquiring signal...',
      name: 'gpsReenabledWarning',
      desc: '',
      args: [],
    );
  }

  /// `GPS is active, updating location (may be indoors)...`
  String get gpsReenabledLeaderWarning {
    return Intl.message(
      'GPS is active, updating location (may be indoors)...',
      name: 'gpsReenabledLeaderWarning',
      desc: '',
      args: [],
    );
  }

  /// `A system error occurred. Please check your permissions.`
  String get gpsSystemError {
    return Intl.message(
      'A system error occurred. Please check your permissions.',
      name: 'gpsSystemError',
      desc: '',
      args: [],
    );
  }

  /// `Tracking stopped because the supervisor lost connection for more than 30 minutes.`
  String get leaderTimeoutError {
    return Intl.message(
      'Tracking stopped because the supervisor lost connection for more than 30 minutes.',
      name: 'leaderTimeoutError',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while ending the session, please try again.`
  String get endSessionError {
    return Intl.message(
      'An error occurred while ending the session, please try again.',
      name: 'endSessionError',
      desc: '',
      args: [],
    );
  }

  /// `A pilgrim`
  String get unknownPilgrim {
    return Intl.message(
      'A pilgrim',
      name: 'unknownPilgrim',
      desc: '',
      args: [],
    );
  }

  /// `Stopped Tracking`
  String get stoppedTracking {
    return Intl.message(
      'Stopped Tracking',
      name: 'stoppedTracking',
      desc: '',
      args: [],
    );
  }

  /// `📍 Location Sharing Request`
  String get locationRequestTitle {
    return Intl.message(
      '📍 Location Sharing Request',
      name: 'locationRequestTitle',
      desc: '',
      args: [],
    );
  }

  /// `Distancing Warning`
  String get pilgrimWarningChannelName {
    return Intl.message(
      'Distancing Warning',
      name: 'pilgrimWarningChannelName',
      desc: '',
      args: [],
    );
  }

  /// `Distancing Alert`
  String get pilgrimEmergencyChannelName {
    return Intl.message(
      'Distancing Alert',
      name: 'pilgrimEmergencyChannelName',
      desc: '',
      args: [],
    );
  }

  /// `🟡 Warning: You are drifting away!`
  String get pilgrimWarningTitle {
    return Intl.message(
      '🟡 Warning: You are drifting away!',
      name: 'pilgrimWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `You are moving away from your group. Hurry back to the supervisor.`
  String get pilgrimWarningBody {
    return Intl.message(
      'You are moving away from your group. Hurry back to the supervisor.',
      name: 'pilgrimWarningBody',
      desc: '',
      args: [],
    );
  }

  /// `🚨 Danger Alert!`
  String get pilgrimEmergencyTitle {
    return Intl.message(
      '🚨 Danger Alert!',
      name: 'pilgrimEmergencyTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have moved beyond the allowed distance from the supervisor!`
  String get pilgrimEmergencyBody {
    return Intl.message(
      'You have moved beyond the allowed distance from the supervisor!',
      name: 'pilgrimEmergencyBody',
      desc: '',
      args: [],
    );
  }

  /// `Late Pilgrims Warnings`
  String get leaderWarningChannelName {
    return Intl.message(
      'Late Pilgrims Warnings',
      name: 'leaderWarningChannelName',
      desc: '',
      args: [],
    );
  }

  /// `Pilgrim Emergency`
  String get leaderEmergencyChannelName {
    return Intl.message(
      'Pilgrim Emergency',
      name: 'leaderEmergencyChannelName',
      desc: '',
      args: [],
    );
  }

  /// `🟡 Pilgrim Lagging Alert`
  String get leaderPilgrimWarningTitle {
    return Intl.message(
      '🟡 Pilgrim Lagging Alert',
      name: 'leaderPilgrimWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pilgrim "{name}" has started drifting from the group.`
  String leaderPilgrimWarningBody(String name) {
    return Intl.message(
      'Pilgrim "$name" has started drifting from the group.',
      name: 'leaderPilgrimWarningBody',
      desc: '',
      args: [name],
    );
  }

  /// `🚨 Danger: Pilgrim Missing!`
  String get leaderPilgrimEmergencyTitle {
    return Intl.message(
      '🚨 Danger: Pilgrim Missing!',
      name: 'leaderPilgrimEmergencyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pilgrim "{name}" has exceeded the safe zone!`
  String leaderPilgrimEmergencyBody(String name) {
    return Intl.message(
      'Pilgrim "$name" has exceeded the safe zone!',
      name: 'leaderPilgrimEmergencyBody',
      desc: '',
      args: [name],
    );
  }

  /// `Location Sharing Request`
  String get locationRequestDialogTitle {
    return Intl.message(
      'Location Sharing Request',
      name: 'locationRequestDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Invite accepted, starting tracking...`
  String get inviteAcceptedMsg {
    return Intl.message(
      'Invite accepted, starting tracking...',
      name: 'inviteAcceptedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Invite rejected successfully`
  String get inviteRejectedMsg {
    return Intl.message(
      'Invite rejected successfully',
      name: 'inviteRejectedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Tracking in Progress`
  String get trackingInProgress {
    return Intl.message(
      'Tracking in Progress',
      name: 'trackingInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message('Join', name: 'join', desc: '', args: []);
  }

  /// `Reject`
  String get dialogReject {
    return Intl.message('Reject', name: 'dialogReject', desc: '', args: []);
  }

  /// `Accept`
  String get dialogAccept {
    return Intl.message('Accept', name: 'dialogAccept', desc: '', args: []);
  }

  /// `Switch Ritual`
  String get switchTrackingType {
    return Intl.message(
      'Switch Ritual',
      name: 'switchTrackingType',
      desc: '',
      args: [],
    );
  }

  /// `The current {currentName} will be stopped and reset from the first lap. Do you want to continue?`
  String switchTrackingTypeWarning(Object currentName) {
    return Intl.message(
      'The current $currentName will be stopped and reset from the first lap. Do you want to continue?',
      name: 'switchTrackingTypeWarning',
      desc: '',
      args: [currentName],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Are you sure you want to delete this location? This action cannot be undone.`
  String get confirmDeleteLocationMessage {
    return Intl.message(
      'Are you sure you want to delete this location? This action cannot be undone.',
      name: 'confirmDeleteLocationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Smart Pilgrim Companion - Be an active leader`
  String get locationTrackingTitle {
    return Intl.message(
      'Smart Pilgrim Companion - Be an active leader',
      name: 'locationTrackingTitle',
      desc: '',
      args: [],
    );
  }

  /// `The app tracks your location to guide pilgrims`
  String get locationTrackingDesc {
    return Intl.message(
      'The app tracks your location to guide pilgrims',
      name: 'locationTrackingDesc',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Operation completed successfully`
  String get operationSuccessful {
    return Intl.message(
      'Operation completed successfully',
      name: 'operationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported data format from server`
  String get unsupportedDataFormat {
    return Intl.message(
      'Unsupported data format from server',
      name: 'unsupportedDataFormat',
      desc: '',
      args: [],
    );
  }

  /// `Do you agree to share your geographic location?`
  String get locationRequestBody {
    return Intl.message(
      'Do you agree to share your geographic location?',
      name: 'locationRequestBody',
      desc: '',
      args: [],
    );
  }

  /// `✅ "{name}" joined the session and started tracking`
  String pilgrimJoinedSession(String name) {
    return Intl.message(
      '✅ "$name" joined the session and started tracking',
      name: 'pilgrimJoinedSession',
      desc: '',
      args: [name],
    );
  }

  /// `❌ "{name}" rejected joining the session`
  String pilgrimRejectedSession(String name) {
    return Intl.message(
      '❌ "$name" rejected joining the session',
      name: 'pilgrimRejectedSession',
      desc: '',
      args: [name],
    );
  }

  /// `⚠️ "{name}" stopped sharing their location`
  String pilgrimStoppedSharingLocation(String name) {
    return Intl.message(
      '⚠️ "$name" stopped sharing their location',
      name: 'pilgrimStoppedSharingLocation',
      desc: '',
      args: [name],
    );
  }

  /// `A pilgrim's status has changed`
  String get pilgrimStatusChanged {
    return Intl.message(
      'A pilgrim\'s status has changed',
      name: 'pilgrimStatusChanged',
      desc: '',
      args: [],
    );
  }

  /// `👥 Pilgrim status changed`
  String get pilgrimStatusChangedTitle {
    return Intl.message(
      '👥 Pilgrim status changed',
      name: 'pilgrimStatusChangedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is disabled. Proximity accuracy will decrease. Please enable it.`
  String get bleClosedLeaderWarning {
    return Intl.message(
      'Bluetooth is disabled. Proximity accuracy will decrease. Please enable it.',
      name: 'bleClosedLeaderWarning',
      desc: '',
      args: [],
    );
  }

  /// `Your device does not support Bluetooth.`
  String get bleNotSupportedLeaderWarning {
    return Intl.message(
      'Your device does not support Bluetooth.',
      name: 'bleNotSupportedLeaderWarning',
      desc: '',
      args: [],
    );
  }

  /// `Please enable GPS to use Bluetooth radar.`
  String get pleaseEnableGpsForBleWarning {
    return Intl.message(
      'Please enable GPS to use Bluetooth radar.',
      name: 'pleaseEnableGpsForBleWarning',
      desc: '',
      args: [],
    );
  }

  /// `Failed to start Bluetooth scan. Ensure GPS and Bluetooth are enabled.`
  String get bleScanFailedWarning {
    return Intl.message(
      'Failed to start Bluetooth scan. Ensure GPS and Bluetooth are enabled.',
      name: 'bleScanFailedWarning',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is disabled. The supervisor won't track you accurately. Please enable it.`
  String get bleClosedPilgrimWarning {
    return Intl.message(
      'Bluetooth is disabled. The supervisor won\'t track you accurately. Please enable it.',
      name: 'bleClosedPilgrimWarning',
      desc: '',
      args: [],
    );
  }

  /// `Your device doesn't support Bluetooth — supervisor won't track you accurately.`
  String get bleNotSupportedPilgrimWarning {
    return Intl.message(
      'Your device doesn\'t support Bluetooth — supervisor won\'t track you accurately.',
      name: 'bleNotSupportedPilgrimWarning',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
