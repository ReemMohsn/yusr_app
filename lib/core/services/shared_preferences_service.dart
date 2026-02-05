import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

class SharedPreferencesService {
  /// نستخدم النسخة الحديثة Async المتوافقة مع الويب والموبايل
  /// لا حاجة لدالة init() في بداية التطبيق
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // ===========================================================================
  // 1. Authentication & Profile Logic (منطق التطبيق)
  // ===========================================================================

  /// التحقق مما إذا كان المستخدم مسجلاً للدخول
  Future<bool> get isLoggedIn async {
    final value = await _prefs.getBool(SharedPreferencesKeys.isLoggedIn);
    return value ?? false;
  }

  /// حفظ حالة تسجيل الدخول
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(SharedPreferencesKeys.isLoggedIn, value);
  }

  /// التحقق من إكمال شاشة البداية (Onboarding)
  Future<bool> get isOnboardingCompleted async {
    final value = await _prefs.getBool(
      SharedPreferencesKeys.onboardingCompleted,
    );
    return value ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(SharedPreferencesKeys.onboardingCompleted, true);
  }

  /// استرجاع بيانات الملف الشخصي
  Future<ProfileModel?> getProfile() async {
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
  Future<void> setProfile(ProfileModel profile) async {
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
  Future<void> removeProfile() async {
    await _prefs.remove(SharedPreferencesKeys.profile);
    await setLoggedIn(false); // تعديل الحالة إلى غير مسجل
  }

  /// مسح جميع البيانات (عند حذف الحساب مثلاً)
  Future<void> clear() async {
    await _prefs.clear();
  }

  // ===========================================================================
  // 2. Generic Helpers (دوال عامة لاستخدامات أخرى)
  // ===========================================================================

  Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  Future<String?> getString(String key) async => await _prefs.getString(key);

  Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  Future<bool?> getBool(String key) async => await _prefs.getBool(key);

  Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  Future<int?> getInt(String key) async => await _prefs.getInt(key);

  Future<void> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  Future<double?> getDouble(String key) async => await _prefs.getDouble(key);

  /// دالة عامة لحفظ أي نوع (كما في الكود القديم لديك)
  Future<void> setValue(String key, dynamic value) async {
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

  /// Remove the saved reset/forgot-password email
  Future<void> removeResetEmail() async {
    await _prefs.remove(SharedPreferencesKeys.resetEmail);
  }

  Future<void> removeOtpCode() async {
    await _prefs.remove(SharedPreferencesKeys.otpCode);
  }
}
