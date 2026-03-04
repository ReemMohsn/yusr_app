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
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
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
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Smart Mufti',
      name: 'smartMufti',
      desc: '',
      args: [],
    );
  }

  /// `Take me back`
  String get returnMe {
    return Intl.message(
      'Take me back',
      name: 'returnMe',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Not found`
  String get notFound {
    return Intl.message(
      'Not found',
      name: 'notFound',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Hijri Date',
      name: 'hijriDate',
      desc: '',
      args: [],
    );
  }

  /// `Fajr`
  String get fajr {
    return Intl.message(
      'Fajr',
      name: 'fajr',
      desc: '',
      args: [],
    );
  }

  /// `Dhuhr`
  String get dhuhr {
    return Intl.message(
      'Dhuhr',
      name: 'dhuhr',
      desc: '',
      args: [],
    );
  }

  /// `Asr`
  String get asr {
    return Intl.message(
      'Asr',
      name: 'asr',
      desc: '',
      args: [],
    );
  }

  /// `Maghrib`
  String get maghrib {
    return Intl.message(
      'Maghrib',
      name: 'maghrib',
      desc: '',
      args: [],
    );
  }

  /// `Isha`
  String get isha {
    return Intl.message(
      'Isha',
      name: 'isha',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Yusr',
      name: 'appName',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Login',
      name: 'loginButton',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Reset',
      name: 'resetButton',
      desc: '',
      args: [],
    );
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
