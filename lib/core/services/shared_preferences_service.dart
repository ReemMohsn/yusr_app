import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

class SharedPreferencesService {
  /// نستخدم النسخة الحديثة Async المتوافقة مع الويب والموبايل
  /// لا حاجة لدالة init() في بداية التطبيق
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // ===========================================================================
  // 1. Authentication & Profile Logic (منطق التطبيق)
  // ===========================================================================

  /// التحقق مما إذا كان المستخدم مسجلاً للدخول
  static Future<bool> get isLoggedIn async {
    final value = await _prefs.getBool(SharedPreferencesKeys.isLoggedIn);
    return value ?? false;
  }

  /// حفظ حالة تسجيل الدخول
  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(SharedPreferencesKeys.isLoggedIn, value);
  }

  /// التحقق من إكمال شاشة البداية (Onboarding)
  static Future<bool> get isOnboardingCompleted async {
    final value = await _prefs.getBool(
      SharedPreferencesKeys.onboardingCompleted,
    );
    return value ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(SharedPreferencesKeys.onboardingCompleted, true);
  }

  /// استرجاع بيانات الملف الشخصي
  static Future<ProfileModel?> getProfile() async {
    final profileString = await _prefs.getString(SharedPreferencesKeys.profile);

    if (profileString != null) {
      try {
        final profileJson = jsonDecode(profileString) as Map<String, dynamic>;
        // debugPrint("Profile loaded from local storage: $profileJson");
        return ProfileModel.fromJson(profileJson);
      } catch (e) {
        debugPrint("Error parsing profile data: $e");
        // في حالة وجود خطأ في البيانات المخزنة، نقوم بحذفها لتجنب المشاكل مستقبلاً
        await removeProfile();
      }
    }
    return null;
  }

  /// حفظ بيانات الملف الشخصي
  static Future<void> setProfile(ProfileModel profile) async {
    try {
      final profileJson = jsonEncode(profile.toJson());
      await _prefs.setString(SharedPreferencesKeys.profile, profileJson);
      // عادة عند حفظ البروفايل نعتبر المستخدم مسجل دخول
      await setLoggedIn(true);
    } catch (e) {
      debugPrint("Error saving profile: $e");
    }
  }

  /// حذف بيانات الملف الشخصي (تسجيل الخروج)
  static Future<void> removeProfile() async {
    await _prefs.remove(SharedPreferencesKeys.profile);
    await setLoggedIn(false); // تعديل الحالة إلى غير مسجل
  }

  /// مسح جميع البيانات (عند حذف الحساب مثلاً)
  static Future<void> clear() async {
    await _prefs.clear();
  }

  // ===========================================================================
  // 2. Generic Helpers (دوال عامة لاستخدامات أخرى)
  // ===========================================================================

  static Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<String?> getString(String key) async =>
      await _prefs.getString(key);

  static Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static Future<bool?> getBool(String key) async => await _prefs.getBool(key);

  static Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<int?> getInt(String key) async => await _prefs.getInt(key);

  static Future<void> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  static Future<double?> getDouble(String key) async =>
      await _prefs.getDouble(key);

  /// دالة عامة لحفظ أي نوع (كما في الكود القديم لديك)
  static Future<void> setValue(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else {
      throw ArgumentError("Unsupported value type");
    }
  }
}
