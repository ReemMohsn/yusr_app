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
/// `Add Location`
  String get addLocation {
    return Intl.message(
      'Add Location',
      name: 'addLocation',
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
    String get locationList {
    return Intl.message(
      'Location List',
      name: 'locationList',
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
    String get locationDescription {
    return Intl.message(
      'Location Description',
      name: 'locationDescription',
      desc: '',
      args: [],
    );
  }
    String get enterLocationDescription {
    return Intl.message(
      'Enter a brief description for the location',
      name: 'enterLocationDescription',
      desc: '',
      args: [],
    );
  }

/// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
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

  /// `Please choose a location first`
  String get chooseCoordinates {
    return Intl.message(
      'Choose location coordinates',
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

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }
  /// `Edit Location`
  String get editLocation {
      return Intl.message(
        'Edit Location',
        name: 'editLocation', // يجب أن يكون مطابقاً لاسم المفتاح
        desc: '',
        args: [],
      );
  }
  /// `An error occurred while fetching data`
  String get fetchDataError {
    return Intl.message(
      'An error occurred while fetching data',
      name: 'fetchDataError',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }
    String get deleteSuccess{
    return Intl.message(
      'Location deleted successfully',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }
      String get updateSuccess{
    return Intl.message(
      'Location updated successfully',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }
        String get changeLocation{
    return Intl.message(
      'Change Location',
      name: 'changeLocation',
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

  /// `Enter location name`
  String get enterLocationName {
    return Intl.message(
      'Enter location name',
      name: 'enterLocationName',
      desc: '',
      args: [],
    );
  }
  
  /// `Delete`
  String get delete {
      return Intl.message(
        'Delete',
        name: 'delete',
        desc: '',
        args: [],
      );
    }

  /// `Are you sure you want to delete this location permanently?`
  String get confirmDelete {
      return Intl.message(
        'Are you sure you want to delete this location permanently?',
        name: 'confirmDelete',
        desc: '',
        args: [],
      );
    }

  String get updateLocationTitle {
      return Intl.message(
        'Update Location', // القيمة الافتراضية
        name: 'updateLocationTitle', // هذا هو أهم سطر
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

  /// `[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival and Makkah Activities","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention and Covenant","items":["Anyone intending Hajj or Umrah should consciously seek closeness to Allah Almighty and purify their intention for this great obligation.","Hajj is an opportunity for sincere repentance, renewing one's covenant with Allah, and abandoning all sins.","Ensure all your wealth funding the Hajj is pure and Halal."],"type":"text"}]},{"name":"Ihram from the Miqat","emoji":"🤲","sections":[{"title":"Instructions and Steps","items":["At or before the Miqat, cleanse yourself, perform Ghusl (full washing), and apply perfume to your body (for men) before putting on the garments.","Men wear two clean, white seamless garments (Izar and Rida). Women wear regular modest clothing without a face-veil (Niqab) or gloves.","Make the intention and recite the Talbiyah: \"Labbayk Allahumma Hajjan\" (Here I am, O Allah, for Hajj).","Begin the continuous Talbiyah: \"Labbayka Allahumma Labbayk...\" and persist in it."],"type":"text"},{"title":"Ihram Prohibitions","items":["Cutting any hair or clipping nails.","Applying perfume to the body or garments.","Covering the head with a fitted cap (for men), or wearing tailored clothes.","Sexual intercourse and its preludes.","Hunting or killing wild game."],"type":"warning"}]},{"name":"Tawaf Al-Qudum (Arrival)","emoji":"🕋","sections":[{"title":"Tawaf Etiquette","items":["It is a Sunnah for the Mufrid and Qarin to perform Tawaf Al-Qudum upon arriving in Makkah.","Stop the Talbiyah when beginning Tawaf. The man should bare his right shoulder (Idtiba) uniquely for this Tawaf.","Walk swiftly with short steps (Raml) during the first three circuits (for men).","Start the Tawaf from the Black Stone, keeping the Kaaba on your left, and complete 7 circuits."],"type":"text"},{"title":"Supplications of Tawaf","items":["Between the Yemeni Corner and the Black Stone, say: \"Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina 'adhaban-nar\" (Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire)."],"type":"dua"}]},{"name":"Station of Ibrahim","emoji":"🕌","sections":[{"title":"The Two Rakahs of Tawaf","items":["After completing Tawaf, head to the Station of Ibrahim and recite: \"And take, [O believers], from the standing place of Abraham a place of prayer.\"","Pray two Rakahs behind the Station if possible, or anywhere in the Sacred Mosque.","Recite Surah Al-Kafirun in the first Rakah and Surah Al-Ikhlas in the second."],"type":"text"}]},{"name":"Zamzam Water","emoji":"💧","sections":[{"title":"Drinking Zamzam","items":["It is recommended to drink deeply from Zamzam water and pour some on your head.","Zamzam water is for whatever it is drunk for, so supplicate to Allah for the good of this world and the Hereafter."],"type":"text"}]},{"name":"Sa'i (Walking)","emoji":"🚶","sections":[{"title":"Sa'i of Hajj","items":["The Mufrid and Qarin can advance the Sa'i of Hajj after Tawaf Al-Qudum (so they do not have to perform Sa'i again on Eid).","Ascend Mount Safa and recite the Quranic verse mentioning Safa and Marwah.","Face the Qiblah, praise Allah, magnify Him three times, and supplicate, then descend walking towards Marwah.","Complete 7 laps, where going from Safa to Marwah is one lap, and returning is another."],"type":"text"},{"title":"Supplications on Safa and Marwah","items":["Allahu Akbar, Allahu Akbar, Allahu Akbar. La ilaha illallahu wahdahu la sharika lah. Lahul mulku wa lahul hamd wahuwa 'ala kulli shay'in qadir. La ilaha illallahu wahdah, anjaza wa'dah, wa nasara 'abdah, wa hazamal ahzaba wahdah."],"type":"dua"}]},{"name":"Staying in Makkah","emoji":"🏨","sections":[{"title":"Waiting in Peace","items":["The Mufrid and Qarin remain in Makkah in their state of Ihram.","Use this time to pray frequently in the Sacred Mosque, recite Quran, and engage in Dhikr, in preparation for the core rites of Hajj."],"type":"text"}]}]},{"title":"The 8th Day","subtitle":"Day of Tarwiyah - 8th Thul-Hijjah","actions":[{"name":"Proceeding to Mina","emoji":"🏕️","sections":[{"title":"Acts of Tarwiyah","items":["Pilgrims head to Mina during the forenoon. (Mutamatti enters Ihram from his location).","Going to Mina on the Day of Tarwiyah is an emphasized Sunnah, not obligatory.","Pray Dhuhr, Asr, Maghrib, Isha, and Fajr of the 9th day in Mina.","Shorten the 4-Rakah prayers to 2 Rakahs (Qasr) but pray each in its respective time without combining.","Engage abundantly in Talbiyah, Dhikr, and reflection on the sanctity of the time."],"type":"text"}]}]},{"title":"The 9th Day","subtitle":"Day of Arafah - 9th Thul-Hijjah","actions":[{"name":"Standing at Arafah","emoji":"⛰️","sections":[{"title":"The Greatest Pillar","items":["After sunrise, move from Mina to Arafah peacefully while reciting Talbiyah.","Pray Dhuhr and Asr together (Jam' Taqdeem) and shortened (Qasr) with one Adhan and two Iqamahs.","Dedicate the entire time to supplication, Dhikr, and sincere pleading, facing the Qiblah with raised hands until sunset.","It is impermissible to leave the boundaries of Arafah before sunset."],"type":"text"},{"title":"The Best Supplication","items":["The best of what I and the Prophets before me have said is: \"La ilaha illallah, wahdahu la sharika lah, lahul mulku wa lahul hamdu, wa huwa 'ala kulli shay'in Qadir\" (There is no deity worthy of worship but Allah alone, having no partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things competent)."],"type":"dua"}]},{"name":"Staying in Muzdalifah","emoji":"🌙","sections":[{"title":"Departing to Muzdalifah","items":["Immediately after sunset, depart to Muzdalifah calmly.","Upon arrival, pray Maghrib (3 Rakahs) and Isha (2 Rakahs) joined (Jam' Ta'kheer).","Sleep in Muzdalifah until Fajr, then stand at the Sacred Monument (or anywhere in Muzdalifah) supplicating until it is very light.","The Prophet ﷺ made a concession for the weak and women to leave Muzdalifah for Mina after midnight."],"type":"text"}]}]},{"title":"The 10th Day","subtitle":"Day of Sacrifice (Eid)","actions":[{"name":"Stoning Jamarat Al-Aqabah","emoji":"🎯","sections":[{"title":"The Stoning","items":["Upon returning to Mina on Eid morning, stone only the major pillar (Jamarat Al-Aqabah) using 7 successive pebbles.","Say \"Allahu Akbar\" with every pebble thrown.","Cut off the Talbiyah when throwing the very first pebble.","Pebbles should be roughly the size of a chickpea and can be picked from Muzdalifah or Mina."],"type":"text"}]},{"name":"Slaughtering the Hady","emoji":"🐑","sections":[{"title":"Rules of Hady","items":["Mufrid: No sacrifice is required.","Qarin & Mutamatti: Required to offer a sacrifice (a sheep, or 1/7th of a camel or cow).","It is permissible to delegate official entities (like the Islamic Development Bank) to slaughter on your behalf."],"type":"text"}]},{"name":"Shaving or Trimming","emoji":"✂️","sections":[{"title":"The First Partial Release","items":["Men should shave their entire head or trim their hair evenly, though shaving is highly preferred.","Women gather their hair and cut approximately an inch (a fingertip's length) from the ends.","This achieves the First Partial Release (Tahallul Al-Awwal), making everything lawful except sexual relations."],"type":"text"}]},{"name":"Tawaf Al-Ifadah","emoji":"🕋","sections":[{"title":"The Second Pillar","items":["Descend to Makkah to perform Tawaf Al-Ifadah (a core pillar without which Hajj is invalid).","Perform 7 circuits. There is no Raml (brisk walking) or Idtiba (baring the shoulder) in this Tawaf.","After this Tawaf (and Sa'i if required), the pilgrim achieves complete release (Tahallul Al-Akbar), and everything is lawful including sexual relations."],"type":"text"}]},{"name":"Sa'i (For those who haven't)","emoji":"🚶","sections":[{"title":"Sa'i of Hajj","items":["Mufrid & Qarin: If they performed Sa'i after Tawaf Al-Qudum, no further Sa'i is required.","Mutamatti: Must perform Sa'i here, because their first Sa'i was for Umrah."],"type":"text"}]}]},{"title":"Days of Tashreeq","subtitle":"11th, 12th, 13th of Thul-Hijjah","actions":[{"name":"Stoning the Three Jamarat","emoji":"🎯","sections":[{"title":"Rules of Stoning","items":["Pilgrims stone all three pillars every day after Zawal (when the time for Dhuhr prayer enters).","Begin with the Smallest Pillar (7 pebbles), then move aside and supplicate at length.","Then the Middle Pillar (7 pebbles), then move aside and supplicate at length.","Finally the Major Pillar of Aqabah (7 pebbles), and then depart without supplicating."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Obligation of Staying","items":["Staying in Mina during the nights of Tashreeq is obligatory.","The pilgrim must spend the majority of the night within the boundaries of Mina.","It is permissible to depart early (Ta'ajjul) on the 12th of Thul-Hijjah, provided one leaves Mina before sunset."],"type":"text"}]}]},{"title":"Concluding the Rites","subtitle":"Departure & Farewell Tawaf","actions":[{"name":"Farewell Tawaf (Wada')","emoji":"🕋","sections":[{"title":"Final Act in Makkah","items":["The Farewell Tawaf is obligatory for every pilgrim leaving Makkah to return to their country.","It must be the very last action performed before traveling.","Perform 7 circuits only; there is no Sa'i or Raml.","Women who are menstruating or experiencing postpartum bleeding are exempted from the Farewell Tawaf."],"type":"text"}]}]}]`
  String get hajjIfradData {
    return Intl.message(
      '[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival and Makkah Activities","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention and Covenant","items":["Anyone intending Hajj or Umrah should consciously seek closeness to Allah Almighty and purify their intention for this great obligation.","Hajj is an opportunity for sincere repentance, renewing one\'s covenant with Allah, and abandoning all sins.","Ensure all your wealth funding the Hajj is pure and Halal."],"type":"text"}]},{"name":"Ihram from the Miqat","emoji":"🤲","sections":[{"title":"Instructions and Steps","items":["At or before the Miqat, cleanse yourself, perform Ghusl (full washing), and apply perfume to your body (for men) before putting on the garments.","Men wear two clean, white seamless garments (Izar and Rida). Women wear regular modest clothing without a face-veil (Niqab) or gloves.","Make the intention and recite the Talbiyah: \\"Labbayk Allahumma Hajjan\\" (Here I am, O Allah, for Hajj).","Begin the continuous Talbiyah: \\"Labbayka Allahumma Labbayk...\\" and persist in it."],"type":"text"},{"title":"Ihram Prohibitions","items":["Cutting any hair or clipping nails.","Applying perfume to the body or garments.","Covering the head with a fitted cap (for men), or wearing tailored clothes.","Sexual intercourse and its preludes.","Hunting or killing wild game."],"type":"warning"}]},{"name":"Tawaf Al-Qudum (Arrival)","emoji":"🕋","sections":[{"title":"Tawaf Etiquette","items":["It is a Sunnah for the Mufrid and Qarin to perform Tawaf Al-Qudum upon arriving in Makkah.","Stop the Talbiyah when beginning Tawaf. The man should bare his right shoulder (Idtiba) uniquely for this Tawaf.","Walk swiftly with short steps (Raml) during the first three circuits (for men).","Start the Tawaf from the Black Stone, keeping the Kaaba on your left, and complete 7 circuits."],"type":"text"},{"title":"Supplications of Tawaf","items":["Between the Yemeni Corner and the Black Stone, say: \\"Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina \'adhaban-nar\\" (Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire)."],"type":"dua"}]},{"name":"Station of Ibrahim","emoji":"🕌","sections":[{"title":"The Two Rakahs of Tawaf","items":["After completing Tawaf, head to the Station of Ibrahim and recite: \\"And take, [O believers], from the standing place of Abraham a place of prayer.\\"","Pray two Rakahs behind the Station if possible, or anywhere in the Sacred Mosque.","Recite Surah Al-Kafirun in the first Rakah and Surah Al-Ikhlas in the second."],"type":"text"}]},{"name":"Zamzam Water","emoji":"💧","sections":[{"title":"Drinking Zamzam","items":["It is recommended to drink deeply from Zamzam water and pour some on your head.","Zamzam water is for whatever it is drunk for, so supplicate to Allah for the good of this world and the Hereafter."],"type":"text"}]},{"name":"Sa\'i (Walking)","emoji":"🚶","sections":[{"title":"Sa\'i of Hajj","items":["The Mufrid and Qarin can advance the Sa\'i of Hajj after Tawaf Al-Qudum (so they do not have to perform Sa\'i again on Eid).","Ascend Mount Safa and recite the Quranic verse mentioning Safa and Marwah.","Face the Qiblah, praise Allah, magnify Him three times, and supplicate, then descend walking towards Marwah.","Complete 7 laps, where going from Safa to Marwah is one lap, and returning is another."],"type":"text"},{"title":"Supplications on Safa and Marwah","items":["Allahu Akbar, Allahu Akbar, Allahu Akbar. La ilaha illallahu wahdahu la sharika lah. Lahul mulku wa lahul hamd wahuwa \'ala kulli shay\'in qadir. La ilaha illallahu wahdah, anjaza wa\'dah, wa nasara \'abdah, wa hazamal ahzaba wahdah."],"type":"dua"}]},{"name":"Staying in Makkah","emoji":"🏨","sections":[{"title":"Waiting in Peace","items":["The Mufrid and Qarin remain in Makkah in their state of Ihram.","Use this time to pray frequently in the Sacred Mosque, recite Quran, and engage in Dhikr, in preparation for the core rites of Hajj."],"type":"text"}]}]},{"title":"The 8th Day","subtitle":"Day of Tarwiyah - 8th Thul-Hijjah","actions":[{"name":"Proceeding to Mina","emoji":"🏕️","sections":[{"title":"Acts of Tarwiyah","items":["Pilgrims head to Mina during the forenoon. (Mutamatti enters Ihram from his location).","Going to Mina on the Day of Tarwiyah is an emphasized Sunnah, not obligatory.","Pray Dhuhr, Asr, Maghrib, Isha, and Fajr of the 9th day in Mina.","Shorten the 4-Rakah prayers to 2 Rakahs (Qasr) but pray each in its respective time without combining.","Engage abundantly in Talbiyah, Dhikr, and reflection on the sanctity of the time."],"type":"text"}]}]},{"title":"The 9th Day","subtitle":"Day of Arafah - 9th Thul-Hijjah","actions":[{"name":"Standing at Arafah","emoji":"⛰️","sections":[{"title":"The Greatest Pillar","items":["After sunrise, move from Mina to Arafah peacefully while reciting Talbiyah.","Pray Dhuhr and Asr together (Jam\' Taqdeem) and shortened (Qasr) with one Adhan and two Iqamahs.","Dedicate the entire time to supplication, Dhikr, and sincere pleading, facing the Qiblah with raised hands until sunset.","It is impermissible to leave the boundaries of Arafah before sunset."],"type":"text"},{"title":"The Best Supplication","items":["The best of what I and the Prophets before me have said is: \\"La ilaha illallah, wahdahu la sharika lah, lahul mulku wa lahul hamdu, wa huwa \'ala kulli shay\'in Qadir\\" (There is no deity worthy of worship but Allah alone, having no partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things competent)."],"type":"dua"}]},{"name":"Staying in Muzdalifah","emoji":"🌙","sections":[{"title":"Departing to Muzdalifah","items":["Immediately after sunset, depart to Muzdalifah calmly.","Upon arrival, pray Maghrib (3 Rakahs) and Isha (2 Rakahs) joined (Jam\' Ta\'kheer).","Sleep in Muzdalifah until Fajr, then stand at the Sacred Monument (or anywhere in Muzdalifah) supplicating until it is very light.","The Prophet ﷺ made a concession for the weak and women to leave Muzdalifah for Mina after midnight."],"type":"text"}]}]},{"title":"The 10th Day","subtitle":"Day of Sacrifice (Eid)","actions":[{"name":"Stoning Jamarat Al-Aqabah","emoji":"🎯","sections":[{"title":"The Stoning","items":["Upon returning to Mina on Eid morning, stone only the major pillar (Jamarat Al-Aqabah) using 7 successive pebbles.","Say \\"Allahu Akbar\\" with every pebble thrown.","Cut off the Talbiyah when throwing the very first pebble.","Pebbles should be roughly the size of a chickpea and can be picked from Muzdalifah or Mina."],"type":"text"}]},{"name":"Slaughtering the Hady","emoji":"🐑","sections":[{"title":"Rules of Hady","items":["Mufrid: No sacrifice is required.","Qarin & Mutamatti: Required to offer a sacrifice (a sheep, or 1/7th of a camel or cow).","It is permissible to delegate official entities (like the Islamic Development Bank) to slaughter on your behalf."],"type":"text"}]},{"name":"Shaving or Trimming","emoji":"✂️","sections":[{"title":"The First Partial Release","items":["Men should shave their entire head or trim their hair evenly, though shaving is highly preferred.","Women gather their hair and cut approximately an inch (a fingertip\'s length) from the ends.","This achieves the First Partial Release (Tahallul Al-Awwal), making everything lawful except sexual relations."],"type":"text"}]},{"name":"Tawaf Al-Ifadah","emoji":"🕋","sections":[{"title":"The Second Pillar","items":["Descend to Makkah to perform Tawaf Al-Ifadah (a core pillar without which Hajj is invalid).","Perform 7 circuits. There is no Raml (brisk walking) or Idtiba (baring the shoulder) in this Tawaf.","After this Tawaf (and Sa\'i if required), the pilgrim achieves complete release (Tahallul Al-Akbar), and everything is lawful including sexual relations."],"type":"text"}]},{"name":"Sa\'i (For those who haven\'t)","emoji":"🚶","sections":[{"title":"Sa\'i of Hajj","items":["Mufrid & Qarin: If they performed Sa\'i after Tawaf Al-Qudum, no further Sa\'i is required.","Mutamatti: Must perform Sa\'i here, because their first Sa\'i was for Umrah."],"type":"text"}]}]},{"title":"Days of Tashreeq","subtitle":"11th, 12th, 13th of Thul-Hijjah","actions":[{"name":"Stoning the Three Jamarat","emoji":"🎯","sections":[{"title":"Rules of Stoning","items":["Pilgrims stone all three pillars every day after Zawal (when the time for Dhuhr prayer enters).","Begin with the Smallest Pillar (7 pebbles), then move aside and supplicate at length.","Then the Middle Pillar (7 pebbles), then move aside and supplicate at length.","Finally the Major Pillar of Aqabah (7 pebbles), and then depart without supplicating."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Obligation of Staying","items":["Staying in Mina during the nights of Tashreeq is obligatory.","The pilgrim must spend the majority of the night within the boundaries of Mina.","It is permissible to depart early (Ta\'ajjul) on the 12th of Thul-Hijjah, provided one leaves Mina before sunset."],"type":"text"}]}]},{"title":"Concluding the Rites","subtitle":"Departure & Farewell Tawaf","actions":[{"name":"Farewell Tawaf (Wada\')","emoji":"🕋","sections":[{"title":"Final Act in Makkah","items":["The Farewell Tawaf is obligatory for every pilgrim leaving Makkah to return to their country.","It must be the very last action performed before traveling.","Perform 7 circuits only; there is no Sa\'i or Raml.","Women who are menstruating or experiencing postpartum bleeding are exempted from the Farewell Tawaf."],"type":"text"}]}]}]',
      name: 'hajjIfradData',
      desc: '',
      args: [],
    );
  }

  /// `[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival for the Qarin","actions":[{"name":"Intention for Qiran","emoji":"🤲","sections":[{"title":"Combining the Intention","items":["He makes the intention saying: \"Labbayk Allahumma 'Umratan wa Hajjan\" (Here I am, O Allah, for Umrah and Hajj).","The Qarin does not exit Ihram like the Mufrid. He remains in the state of Ihram until the Day of Sacrifice."],"type":"text"}]},{"name":"Arrival Tawaf and Sa'i","emoji":"🕋","sections":[{"title":"Tawaf and Sa'i","items":["He performs Tawaf of Arrival (7 circuits). He may also perform 7 laps of Sa'i, which will suffice him for the Sa'i of Hajj.","He remains in his Ihram after this Sa'i, and does neither shave nor trim."],"type":"text"}]}]},{"title":"The 8th Day","subtitle":"Day of Tarwiyah - 8th Thul-Hijjah","actions":[{"name":"Proceeding to Mina","emoji":"🏕️","sections":[{"title":"Acts of Tarwiyah","items":["Pilgrims head to Mina during the forenoon. (Mutamatti enters Ihram from his location).","Going to Mina on the Day of Tarwiyah is an emphasized Sunnah, not obligatory.","Pray Dhuhr, Asr, Maghrib, Isha, and Fajr of the 9th day in Mina.","Shorten the 4-Rakah prayers to 2 Rakahs (Qasr) but pray each in its respective time without combining.","Engage abundantly in Talbiyah, Dhikr, and reflection on the sanctity of the time."],"type":"text"}]}]},{"title":"The 9th Day","subtitle":"Day of Arafah - 9th Thul-Hijjah","actions":[{"name":"Standing at Arafah","emoji":"⛰️","sections":[{"title":"The Greatest Pillar","items":["After sunrise, move from Mina to Arafah peacefully while reciting Talbiyah.","Pray Dhuhr and Asr together (Jam' Taqdeem) and shortened (Qasr) with one Adhan and two Iqamahs.","Dedicate the entire time to supplication, Dhikr, and sincere pleading, facing the Qiblah with raised hands until sunset.","It is impermissible to leave the boundaries of Arafah before sunset."],"type":"text"},{"title":"The Best Supplication","items":["The best of what I and the Prophets before me have said is: \"La ilaha illallah, wahdahu la sharika lah, lahul mulku wa lahul hamdu, wa huwa 'ala kulli shay'in Qadir\" (There is no deity worthy of worship but Allah alone, having no partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things competent)."],"type":"dua"}]},{"name":"Staying in Muzdalifah","emoji":"🌙","sections":[{"title":"Departing to Muzdalifah","items":["Immediately after sunset, depart to Muzdalifah calmly.","Upon arrival, pray Maghrib (3 Rakahs) and Isha (2 Rakahs) joined (Jam' Ta'kheer).","Sleep in Muzdalifah until Fajr, then stand at the Sacred Monument (or anywhere in Muzdalifah) supplicating until it is very light.","The Prophet ﷺ made a concession for the weak and women to leave Muzdalifah for Mina after midnight."],"type":"text"}]}]},{"title":"The 10th Day","subtitle":"Day of Sacrifice (Eid)","actions":[{"name":"Stoning Jamarat Al-Aqabah","emoji":"🎯","sections":[{"title":"The Stoning","items":["Upon returning to Mina on Eid morning, stone only the major pillar (Jamarat Al-Aqabah) using 7 successive pebbles.","Say \"Allahu Akbar\" with every pebble thrown.","Cut off the Talbiyah when throwing the very first pebble.","Pebbles should be roughly the size of a chickpea and can be picked from Muzdalifah or Mina."],"type":"text"}]},{"name":"Slaughtering the Hady","emoji":"🐑","sections":[{"title":"Rules of Hady","items":["Mufrid: No sacrifice is required.","Qarin & Mutamatti: Required to offer a sacrifice (a sheep, or 1/7th of a camel or cow).","It is permissible to delegate official entities (like the Islamic Development Bank) to slaughter on your behalf."],"type":"text"}]},{"name":"Shaving or Trimming","emoji":"✂️","sections":[{"title":"The First Partial Release","items":["Men should shave their entire head or trim their hair evenly, though shaving is highly preferred.","Women gather their hair and cut approximately an inch (a fingertip's length) from the ends.","This achieves the First Partial Release (Tahallul Al-Awwal), making everything lawful except sexual relations."],"type":"text"}]},{"name":"Tawaf Al-Ifadah","emoji":"🕋","sections":[{"title":"The Second Pillar","items":["Descend to Makkah to perform Tawaf Al-Ifadah (a core pillar without which Hajj is invalid).","Perform 7 circuits. There is no Raml (brisk walking) or Idtiba (baring the shoulder) in this Tawaf.","After this Tawaf (and Sa'i if required), the pilgrim achieves complete release (Tahallul Al-Akbar), and everything is lawful including sexual relations."],"type":"text"}]},{"name":"Sa'i (For those who haven't)","emoji":"🚶","sections":[{"title":"Sa'i of Hajj","items":["Mufrid & Qarin: If they performed Sa'i after Tawaf Al-Qudum, no further Sa'i is required.","Mutamatti: Must perform Sa'i here, because their first Sa'i was for Umrah."],"type":"text"}]}]},{"title":"Days of Tashreeq","subtitle":"11th, 12th, 13th of Thul-Hijjah","actions":[{"name":"Stoning the Three Jamarat","emoji":"🎯","sections":[{"title":"Rules of Stoning","items":["Pilgrims stone all three pillars every day after Zawal (when the time for Dhuhr prayer enters).","Begin with the Smallest Pillar (7 pebbles), then move aside and supplicate at length.","Then the Middle Pillar (7 pebbles), then move aside and supplicate at length.","Finally the Major Pillar of Aqabah (7 pebbles), and then depart without supplicating."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Obligation of Staying","items":["Staying in Mina during the nights of Tashreeq is obligatory.","The pilgrim must spend the majority of the night within the boundaries of Mina.","It is permissible to depart early (Ta'ajjul) on the 12th of Thul-Hijjah, provided one leaves Mina before sunset."],"type":"text"}]}]},{"title":"Concluding the Rites","subtitle":"Departure & Farewell Tawaf","actions":[{"name":"Farewell Tawaf (Wada')","emoji":"🕋","sections":[{"title":"Final Act in Makkah","items":["The Farewell Tawaf is obligatory for every pilgrim leaving Makkah to return to their country.","It must be the very last action performed before traveling.","Perform 7 circuits only; there is no Sa'i or Raml.","Women who are menstruating or experiencing postpartum bleeding are exempted from the Farewell Tawaf."],"type":"text"}]}]}]`
  String get hajjQiranData {
    return Intl.message(
      '[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Arrival for the Qarin","actions":[{"name":"Intention for Qiran","emoji":"🤲","sections":[{"title":"Combining the Intention","items":["He makes the intention saying: \\"Labbayk Allahumma \'Umratan wa Hajjan\\" (Here I am, O Allah, for Umrah and Hajj).","The Qarin does not exit Ihram like the Mufrid. He remains in the state of Ihram until the Day of Sacrifice."],"type":"text"}]},{"name":"Arrival Tawaf and Sa\'i","emoji":"🕋","sections":[{"title":"Tawaf and Sa\'i","items":["He performs Tawaf of Arrival (7 circuits). He may also perform 7 laps of Sa\'i, which will suffice him for the Sa\'i of Hajj.","He remains in his Ihram after this Sa\'i, and does neither shave nor trim."],"type":"text"}]}]},{"title":"The 8th Day","subtitle":"Day of Tarwiyah - 8th Thul-Hijjah","actions":[{"name":"Proceeding to Mina","emoji":"🏕️","sections":[{"title":"Acts of Tarwiyah","items":["Pilgrims head to Mina during the forenoon. (Mutamatti enters Ihram from his location).","Going to Mina on the Day of Tarwiyah is an emphasized Sunnah, not obligatory.","Pray Dhuhr, Asr, Maghrib, Isha, and Fajr of the 9th day in Mina.","Shorten the 4-Rakah prayers to 2 Rakahs (Qasr) but pray each in its respective time without combining.","Engage abundantly in Talbiyah, Dhikr, and reflection on the sanctity of the time."],"type":"text"}]}]},{"title":"The 9th Day","subtitle":"Day of Arafah - 9th Thul-Hijjah","actions":[{"name":"Standing at Arafah","emoji":"⛰️","sections":[{"title":"The Greatest Pillar","items":["After sunrise, move from Mina to Arafah peacefully while reciting Talbiyah.","Pray Dhuhr and Asr together (Jam\' Taqdeem) and shortened (Qasr) with one Adhan and two Iqamahs.","Dedicate the entire time to supplication, Dhikr, and sincere pleading, facing the Qiblah with raised hands until sunset.","It is impermissible to leave the boundaries of Arafah before sunset."],"type":"text"},{"title":"The Best Supplication","items":["The best of what I and the Prophets before me have said is: \\"La ilaha illallah, wahdahu la sharika lah, lahul mulku wa lahul hamdu, wa huwa \'ala kulli shay\'in Qadir\\" (There is no deity worthy of worship but Allah alone, having no partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things competent)."],"type":"dua"}]},{"name":"Staying in Muzdalifah","emoji":"🌙","sections":[{"title":"Departing to Muzdalifah","items":["Immediately after sunset, depart to Muzdalifah calmly.","Upon arrival, pray Maghrib (3 Rakahs) and Isha (2 Rakahs) joined (Jam\' Ta\'kheer).","Sleep in Muzdalifah until Fajr, then stand at the Sacred Monument (or anywhere in Muzdalifah) supplicating until it is very light.","The Prophet ﷺ made a concession for the weak and women to leave Muzdalifah for Mina after midnight."],"type":"text"}]}]},{"title":"The 10th Day","subtitle":"Day of Sacrifice (Eid)","actions":[{"name":"Stoning Jamarat Al-Aqabah","emoji":"🎯","sections":[{"title":"The Stoning","items":["Upon returning to Mina on Eid morning, stone only the major pillar (Jamarat Al-Aqabah) using 7 successive pebbles.","Say \\"Allahu Akbar\\" with every pebble thrown.","Cut off the Talbiyah when throwing the very first pebble.","Pebbles should be roughly the size of a chickpea and can be picked from Muzdalifah or Mina."],"type":"text"}]},{"name":"Slaughtering the Hady","emoji":"🐑","sections":[{"title":"Rules of Hady","items":["Mufrid: No sacrifice is required.","Qarin & Mutamatti: Required to offer a sacrifice (a sheep, or 1/7th of a camel or cow).","It is permissible to delegate official entities (like the Islamic Development Bank) to slaughter on your behalf."],"type":"text"}]},{"name":"Shaving or Trimming","emoji":"✂️","sections":[{"title":"The First Partial Release","items":["Men should shave their entire head or trim their hair evenly, though shaving is highly preferred.","Women gather their hair and cut approximately an inch (a fingertip\'s length) from the ends.","This achieves the First Partial Release (Tahallul Al-Awwal), making everything lawful except sexual relations."],"type":"text"}]},{"name":"Tawaf Al-Ifadah","emoji":"🕋","sections":[{"title":"The Second Pillar","items":["Descend to Makkah to perform Tawaf Al-Ifadah (a core pillar without which Hajj is invalid).","Perform 7 circuits. There is no Raml (brisk walking) or Idtiba (baring the shoulder) in this Tawaf.","After this Tawaf (and Sa\'i if required), the pilgrim achieves complete release (Tahallul Al-Akbar), and everything is lawful including sexual relations."],"type":"text"}]},{"name":"Sa\'i (For those who haven\'t)","emoji":"🚶","sections":[{"title":"Sa\'i of Hajj","items":["Mufrid & Qarin: If they performed Sa\'i after Tawaf Al-Qudum, no further Sa\'i is required.","Mutamatti: Must perform Sa\'i here, because their first Sa\'i was for Umrah."],"type":"text"}]}]},{"title":"Days of Tashreeq","subtitle":"11th, 12th, 13th of Thul-Hijjah","actions":[{"name":"Stoning the Three Jamarat","emoji":"🎯","sections":[{"title":"Rules of Stoning","items":["Pilgrims stone all three pillars every day after Zawal (when the time for Dhuhr prayer enters).","Begin with the Smallest Pillar (7 pebbles), then move aside and supplicate at length.","Then the Middle Pillar (7 pebbles), then move aside and supplicate at length.","Finally the Major Pillar of Aqabah (7 pebbles), and then depart without supplicating."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Obligation of Staying","items":["Staying in Mina during the nights of Tashreeq is obligatory.","The pilgrim must spend the majority of the night within the boundaries of Mina.","It is permissible to depart early (Ta\'ajjul) on the 12th of Thul-Hijjah, provided one leaves Mina before sunset."],"type":"text"}]}]},{"title":"Concluding the Rites","subtitle":"Departure & Farewell Tawaf","actions":[{"name":"Farewell Tawaf (Wada\')","emoji":"🕋","sections":[{"title":"Final Act in Makkah","items":["The Farewell Tawaf is obligatory for every pilgrim leaving Makkah to return to their country.","It must be the very last action performed before traveling.","Perform 7 circuits only; there is no Sa\'i or Raml.","Women who are menstruating or experiencing postpartum bleeding are exempted from the Farewell Tawaf."],"type":"text"}]}]}]',
      name: 'hajjQiranData',
      desc: '',
      args: [],
    );
  }

  /// `[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Performing Umrah for Tamattu","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention for Tamattu","items":["At the Miqat, the pilgrim intends only Umrah by saying: \"Labbayk Allahumma 'Umratan mutamatti'an biha ilal-Hajj\" (Here I am, O Allah, for Umrah seeking the enjoyment of release until Hajj)."],"type":"text"}]},{"name":"Tawaf and Sa'i of Umrah","emoji":"🕋","sections":[{"title":"A Complete Umrah","items":["Arrive in Makkah, perform Tawaf of the Kaaba (7 circuits) for Umrah, and Sa'i between Safa and Marwah (7 laps) for Umrah."],"type":"text"}]},{"name":"Hair Trimming and Release","emoji":"✂️","sections":[{"title":"Complete Release from Umrah","items":["The pilgrim trims his hair (rather than shaving, to save the shaving for Hajj).","By doing so, the pilgrim fully exits the state of Ihram, wears regular clothes, and all prohibitions are lifted until the 8th of Thul-Hijjah."],"type":"text"}]}]},{"title":"The 8th Day","subtitle":"Day of Tarwiyah & Ihram for Hajj","actions":[{"name":"Ihram from Makkah","emoji":"🤲","sections":[{"title":"Intention for Hajj","items":["The Mutamatti bathes, applies perfume, and puts on the Ihram garments from his residence in Makkah.","He recites the Talbiyah saying: \"Labbayk Allahumma Hajjan\"."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Acts of Tarwiyah","items":["He heads to Mina with the pilgrims to pray Dhuhr, Asr, Maghrib, Isha, and Fajr of the 9th, shortened but not combined."],"type":"text"}]}]},{"title":"The 9th Day","subtitle":"Day of Arafah - 9th Thul-Hijjah","actions":[{"name":"Standing at Arafah","emoji":"⛰️","sections":[{"title":"The Greatest Pillar","items":["After sunrise, move from Mina to Arafah peacefully while reciting Talbiyah.","Pray Dhuhr and Asr together (Jam' Taqdeem) and shortened (Qasr) with one Adhan and two Iqamahs.","Dedicate the entire time to supplication, Dhikr, and sincere pleading, facing the Qiblah with raised hands until sunset.","It is impermissible to leave the boundaries of Arafah before sunset."],"type":"text"},{"title":"The Best Supplication","items":["The best of what I and the Prophets before me have said is: \"La ilaha illallah, wahdahu la sharika lah, lahul mulku wa lahul hamdu, wa huwa 'ala kulli shay'in Qadir\" (There is no deity worthy of worship but Allah alone, having no partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things competent)."],"type":"dua"}]},{"name":"Staying in Muzdalifah","emoji":"🌙","sections":[{"title":"Departing to Muzdalifah","items":["Immediately after sunset, depart to Muzdalifah calmly.","Upon arrival, pray Maghrib (3 Rakahs) and Isha (2 Rakahs) joined (Jam' Ta'kheer).","Sleep in Muzdalifah until Fajr, then stand at the Sacred Monument (or anywhere in Muzdalifah) supplicating until it is very light.","The Prophet ﷺ made a concession for the weak and women to leave Muzdalifah for Mina after midnight."],"type":"text"}]}]},{"title":"The 10th Day","subtitle":"Day of Sacrifice (Eid)","actions":[{"name":"Stoning Jamarat Al-Aqabah","emoji":"🎯","sections":[{"title":"The Stoning","items":["Upon returning to Mina on Eid morning, stone only the major pillar (Jamarat Al-Aqabah) using 7 successive pebbles.","Say \"Allahu Akbar\" with every pebble thrown.","Cut off the Talbiyah when throwing the very first pebble.","Pebbles should be roughly the size of a chickpea and can be picked from Muzdalifah or Mina."],"type":"text"}]},{"name":"Slaughtering the Hady","emoji":"🐑","sections":[{"title":"Rules of Hady","items":["Mufrid: No sacrifice is required.","Qarin & Mutamatti: Required to offer a sacrifice (a sheep, or 1/7th of a camel or cow).","It is permissible to delegate official entities (like the Islamic Development Bank) to slaughter on your behalf."],"type":"text"}]},{"name":"Shaving or Trimming","emoji":"✂️","sections":[{"title":"The First Partial Release","items":["Men should shave their entire head or trim their hair evenly, though shaving is highly preferred.","Women gather their hair and cut approximately an inch (a fingertip's length) from the ends.","This achieves the First Partial Release (Tahallul Al-Awwal), making everything lawful except sexual relations."],"type":"text"}]},{"name":"Tawaf Al-Ifadah","emoji":"🕋","sections":[{"title":"The Second Pillar","items":["Descend to Makkah to perform Tawaf Al-Ifadah (a core pillar without which Hajj is invalid).","Perform 7 circuits. There is no Raml (brisk walking) or Idtiba (baring the shoulder) in this Tawaf.","After this Tawaf (and Sa'i if required), the pilgrim achieves complete release (Tahallul Al-Akbar), and everything is lawful including sexual relations."],"type":"text"}]},{"name":"Sa'i (For those who haven't)","emoji":"🚶","sections":[{"title":"Sa'i of Hajj","items":["Mufrid & Qarin: If they performed Sa'i after Tawaf Al-Qudum, no further Sa'i is required.","Mutamatti: Must perform Sa'i here, because their first Sa'i was for Umrah."],"type":"text"}]}]},{"title":"Days of Tashreeq","subtitle":"11th, 12th, 13th of Thul-Hijjah","actions":[{"name":"Stoning the Three Jamarat","emoji":"🎯","sections":[{"title":"Rules of Stoning","items":["Pilgrims stone all three pillars every day after Zawal (when the time for Dhuhr prayer enters).","Begin with the Smallest Pillar (7 pebbles), then move aside and supplicate at length.","Then the Middle Pillar (7 pebbles), then move aside and supplicate at length.","Finally the Major Pillar of Aqabah (7 pebbles), and then depart without supplicating."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Obligation of Staying","items":["Staying in Mina during the nights of Tashreeq is obligatory.","The pilgrim must spend the majority of the night within the boundaries of Mina.","It is permissible to depart early (Ta'ajjul) on the 12th of Thul-Hijjah, provided one leaves Mina before sunset."],"type":"text"}]}]},{"title":"Concluding the Rites","subtitle":"Departure & Farewell Tawaf","actions":[{"name":"Farewell Tawaf (Wada')","emoji":"🕋","sections":[{"title":"Final Act in Makkah","items":["The Farewell Tawaf is obligatory for every pilgrim leaving Makkah to return to their country.","It must be the very last action performed before traveling.","Perform 7 circuits only; there is no Sa'i or Raml.","Women who are menstruating or experiencing postpartum bleeding are exempted from the Farewell Tawaf."],"type":"text"}]}]}]`
  String get hajjTamattuData {
    return Intl.message(
      '[{"title":"Before the 8th of Thul-Hijjah","subtitle":"Performing Umrah for Tamattu","actions":[{"name":"Etiquette and Guidelines","emoji":"📖","sections":[{"title":"Intention for Tamattu","items":["At the Miqat, the pilgrim intends only Umrah by saying: \\"Labbayk Allahumma \'Umratan mutamatti\'an biha ilal-Hajj\\" (Here I am, O Allah, for Umrah seeking the enjoyment of release until Hajj)."],"type":"text"}]},{"name":"Tawaf and Sa\'i of Umrah","emoji":"🕋","sections":[{"title":"A Complete Umrah","items":["Arrive in Makkah, perform Tawaf of the Kaaba (7 circuits) for Umrah, and Sa\'i between Safa and Marwah (7 laps) for Umrah."],"type":"text"}]},{"name":"Hair Trimming and Release","emoji":"✂️","sections":[{"title":"Complete Release from Umrah","items":["The pilgrim trims his hair (rather than shaving, to save the shaving for Hajj).","By doing so, the pilgrim fully exits the state of Ihram, wears regular clothes, and all prohibitions are lifted until the 8th of Thul-Hijjah."],"type":"text"}]}]},{"title":"The 8th Day","subtitle":"Day of Tarwiyah & Ihram for Hajj","actions":[{"name":"Ihram from Makkah","emoji":"🤲","sections":[{"title":"Intention for Hajj","items":["The Mutamatti bathes, applies perfume, and puts on the Ihram garments from his residence in Makkah.","He recites the Talbiyah saying: \\"Labbayk Allahumma Hajjan\\"."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Acts of Tarwiyah","items":["He heads to Mina with the pilgrims to pray Dhuhr, Asr, Maghrib, Isha, and Fajr of the 9th, shortened but not combined."],"type":"text"}]}]},{"title":"The 9th Day","subtitle":"Day of Arafah - 9th Thul-Hijjah","actions":[{"name":"Standing at Arafah","emoji":"⛰️","sections":[{"title":"The Greatest Pillar","items":["After sunrise, move from Mina to Arafah peacefully while reciting Talbiyah.","Pray Dhuhr and Asr together (Jam\' Taqdeem) and shortened (Qasr) with one Adhan and two Iqamahs.","Dedicate the entire time to supplication, Dhikr, and sincere pleading, facing the Qiblah with raised hands until sunset.","It is impermissible to leave the boundaries of Arafah before sunset."],"type":"text"},{"title":"The Best Supplication","items":["The best of what I and the Prophets before me have said is: \\"La ilaha illallah, wahdahu la sharika lah, lahul mulku wa lahul hamdu, wa huwa \'ala kulli shay\'in Qadir\\" (There is no deity worthy of worship but Allah alone, having no partner. To Him belongs the dominion, to Him belongs all praise, and He is over all things competent)."],"type":"dua"}]},{"name":"Staying in Muzdalifah","emoji":"🌙","sections":[{"title":"Departing to Muzdalifah","items":["Immediately after sunset, depart to Muzdalifah calmly.","Upon arrival, pray Maghrib (3 Rakahs) and Isha (2 Rakahs) joined (Jam\' Ta\'kheer).","Sleep in Muzdalifah until Fajr, then stand at the Sacred Monument (or anywhere in Muzdalifah) supplicating until it is very light.","The Prophet ﷺ made a concession for the weak and women to leave Muzdalifah for Mina after midnight."],"type":"text"}]}]},{"title":"The 10th Day","subtitle":"Day of Sacrifice (Eid)","actions":[{"name":"Stoning Jamarat Al-Aqabah","emoji":"🎯","sections":[{"title":"The Stoning","items":["Upon returning to Mina on Eid morning, stone only the major pillar (Jamarat Al-Aqabah) using 7 successive pebbles.","Say \\"Allahu Akbar\\" with every pebble thrown.","Cut off the Talbiyah when throwing the very first pebble.","Pebbles should be roughly the size of a chickpea and can be picked from Muzdalifah or Mina."],"type":"text"}]},{"name":"Slaughtering the Hady","emoji":"🐑","sections":[{"title":"Rules of Hady","items":["Mufrid: No sacrifice is required.","Qarin & Mutamatti: Required to offer a sacrifice (a sheep, or 1/7th of a camel or cow).","It is permissible to delegate official entities (like the Islamic Development Bank) to slaughter on your behalf."],"type":"text"}]},{"name":"Shaving or Trimming","emoji":"✂️","sections":[{"title":"The First Partial Release","items":["Men should shave their entire head or trim their hair evenly, though shaving is highly preferred.","Women gather their hair and cut approximately an inch (a fingertip\'s length) from the ends.","This achieves the First Partial Release (Tahallul Al-Awwal), making everything lawful except sexual relations."],"type":"text"}]},{"name":"Tawaf Al-Ifadah","emoji":"🕋","sections":[{"title":"The Second Pillar","items":["Descend to Makkah to perform Tawaf Al-Ifadah (a core pillar without which Hajj is invalid).","Perform 7 circuits. There is no Raml (brisk walking) or Idtiba (baring the shoulder) in this Tawaf.","After this Tawaf (and Sa\'i if required), the pilgrim achieves complete release (Tahallul Al-Akbar), and everything is lawful including sexual relations."],"type":"text"}]},{"name":"Sa\'i (For those who haven\'t)","emoji":"🚶","sections":[{"title":"Sa\'i of Hajj","items":["Mufrid & Qarin: If they performed Sa\'i after Tawaf Al-Qudum, no further Sa\'i is required.","Mutamatti: Must perform Sa\'i here, because their first Sa\'i was for Umrah."],"type":"text"}]}]},{"title":"Days of Tashreeq","subtitle":"11th, 12th, 13th of Thul-Hijjah","actions":[{"name":"Stoning the Three Jamarat","emoji":"🎯","sections":[{"title":"Rules of Stoning","items":["Pilgrims stone all three pillars every day after Zawal (when the time for Dhuhr prayer enters).","Begin with the Smallest Pillar (7 pebbles), then move aside and supplicate at length.","Then the Middle Pillar (7 pebbles), then move aside and supplicate at length.","Finally the Major Pillar of Aqabah (7 pebbles), and then depart without supplicating."],"type":"text"}]},{"name":"Staying in Mina","emoji":"🏕️","sections":[{"title":"Obligation of Staying","items":["Staying in Mina during the nights of Tashreeq is obligatory.","The pilgrim must spend the majority of the night within the boundaries of Mina.","It is permissible to depart early (Ta\'ajjul) on the 12th of Thul-Hijjah, provided one leaves Mina before sunset."],"type":"text"}]}]},{"title":"Concluding the Rites","subtitle":"Departure & Farewell Tawaf","actions":[{"name":"Farewell Tawaf (Wada\')","emoji":"🕋","sections":[{"title":"Final Act in Makkah","items":["The Farewell Tawaf is obligatory for every pilgrim leaving Makkah to return to their country.","It must be the very last action performed before traveling.","Perform 7 circuits only; there is no Sa\'i or Raml.","Women who are menstruating or experiencing postpartum bleeding are exempted from the Farewell Tawaf."],"type":"text"}]}]}]',
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

  /// `To ensure a safe journey and arrive peacefully, please login first`

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