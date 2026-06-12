import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:yusr/core/common/models/sync_data_model.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';

class NotificationService {
  final SharedPreferencesService prefsService;
  final ApiService apiService;

  NotificationService(this.prefsService, this.apiService);

  Future<void> syncUserTopics({int maxRetries = 3}) async {
    int attempt = 0; // عداد المحاولات

    while (attempt < maxRetries) {
      try {
        final profile = await prefsService.getProfile();
        if (profile == null) return;

        final role = profile.userRole.trim();
        debugPrint("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy$role");

        if (role == "مدير الحملة") {
          debugPrint("المستخدم مدير حملة: تم تخطي المزامنة.");
          return; // إنهاء الدالة بنجاح
        }

        // جلب البيانات من الـ API
        final response = await repositoryRequestHandler<SyncDataModel>(
          () => apiService.get(ApiLink.syncData),
          fromJson: (data) => SyncDataModel.fromJson(data),
        );

        final syncData = response.data;

        if (syncData != null) {
          int campaignId = syncData.campaignId;
          int? currentGroupId = syncData.groupId;

          // حفظ رقم الحملة لاستخدامه عند تسجيل الخروج
          await prefsService.setInt(SharedPreferencesKeys.savedCampaignId, campaignId);

          // الاشتراك في القنوات العامة
          if (role == 'حاج') {
            await FirebaseMessaging.instance.subscribeToTopic(
              'campaign_${campaignId}_hajjis',
            );
            await FirebaseMessaging.instance.subscribeToTopic(
              'campaign_${campaignId}_all',
            );
          } else if (role == 'مشرف') {
            await FirebaseMessaging.instance.subscribeToTopic(
              'campaign_${campaignId}_supervisors',
            );
            await FirebaseMessaging.instance.subscribeToTopic(
              'campaign_${campaignId}_all',
            );
          }

          // معالجة قناة المجموعة للحاج والمشرف
          if (role == 'حاج' || role == 'مشرف') {
            int? savedGroupId = await prefsService.getInt(SharedPreferencesKeys.savedGroupId);

            // 1. إلغاء الاشتراك من المجموعة القديمة (إذا تغيرت المجموعة)
            if (savedGroupId != null && currentGroupId != savedGroupId) {
              String oldTopic = role == 'حاج'
                  ? 'campaign_${campaignId}_group_$savedGroupId'
                  : 'campaign_${campaignId}_supervisor_group_$savedGroupId';
              await FirebaseMessaging.instance.unsubscribeFromTopic(oldTopic);
              debugPrint('🚫 تم إلغاء الاشتراك من القناة القديمة: $oldTopic');
            }

            // 2. الاشتراك الدائم في المجموعة الحالية (حتى لو لم تتغير، لضمان الاشتراك)
            if (currentGroupId != null) {
              String newTopic = role == 'حاج'
                  ? 'campaign_${campaignId}_group_$currentGroupId'
                  : 'campaign_${campaignId}_supervisor_group_$currentGroupId';

              await FirebaseMessaging.instance.subscribeToTopic(newTopic);
              await prefsService.setInt(SharedPreferencesKeys.savedGroupId, currentGroupId);
              debugPrint('✅ تم تأكيد الاشتراك في قناة المجموعة: $newTopic');
            } else {
              await prefsService.removeInt(SharedPreferencesKeys.savedGroupId);
              debugPrint('⚠️ لم يتم إرجاع GroupId من الباك إند للمستخدم!');
            }
          }
        }

        debugPrint(
          '✅ تمت مزامنة الإشعارات بنجاح في المحاولة رقم ${attempt + 1}',
        );
        return; // 🚀 الأهم: خروج من الدالة نهائياً بمجرد النجاح ولن يكمل الحلقة (Loop)
      } catch (e) {
        attempt++; // زيادة العداد
        debugPrint('⚠️ فشلت المزامنة في المحاولة رقم $attempt. السبب: $e');

        if (attempt >= maxRetries) {
          debugPrint(
            '❌ استنفدت كل المحاولات ($maxRetries). يرجى التأكد من اتصال الإنترنت.',
          );
          break; // إيقاف الحلقة بعد 3 محاولات فاشلة
        }
        // انتظار 5 ثوانٍ قبل المحاولة التالية (لإعطاء فرصة للإنترنت للعودة)
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  // دالة لتنظيف الإشعارات عند تسجيل الخروج
  Future<void> clearTopicsOnLogout() async {
    try {
      final profile = await prefsService.getProfile();
      int? campaignId = await prefsService.getInt(SharedPreferencesKeys.savedCampaignId);
      int? savedGroupId = await prefsService.getInt(SharedPreferencesKeys.savedGroupId);

      if (profile != null && campaignId != null) {
        final role = profile.userRole.trim();

        // إلغاء الاشتراك بشكل صريح من جميع القنوات المحتملة بناءً على الدور الحالي
        if (role == 'حاج') {
          await FirebaseMessaging.instance.unsubscribeFromTopic(
            'campaign_${campaignId}_hajjis',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic(
            'campaign_${campaignId}_all',
          );
          if (savedGroupId != null) {
            await FirebaseMessaging.instance.unsubscribeFromTopic(
              'campaign_${campaignId}_group_$savedGroupId',
            );
          }
        } else if (role == 'مشرف') {
          await FirebaseMessaging.instance.unsubscribeFromTopic(
            'campaign_${campaignId}_supervisors',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic(
            'campaign_${campaignId}_all',
          );
          if (savedGroupId != null) {
            await FirebaseMessaging.instance.unsubscribeFromTopic(
              'campaign_${campaignId}_supervisor_group_$savedGroupId',
            );
          }
        }
      }

      // مسح المتغيرات المحفوظة محلياً لمنع تداخلها مع الحسابات الأخرى
      await prefsService.removeInt(SharedPreferencesKeys.savedCampaignId);
      await prefsService.removeInt(SharedPreferencesKeys.savedGroupId);

      // مسح التوكن كإجراء إضافي
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint("خطأ في حذف الاشتراكات: $e");
    }
  }
}
