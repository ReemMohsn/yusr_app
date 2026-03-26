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

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
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

  /// `You are here`
  String get youAreHere {
    return Intl.message('You are here', name: 'youAreHere', desc: '', args: []);
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
