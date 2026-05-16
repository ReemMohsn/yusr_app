import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';

class SyncDataModel {
  final int campaignId;
  final int? groupId;

  SyncDataModel({required this.campaignId, this.groupId});

  factory SyncDataModel.fromJson(Map<String, dynamic> json) {
    return SyncDataModel(
      campaignId: json['campaignId'] ?? json['CampaignId'],
      groupId: json['groupId'] ?? json['GroupId'],
    );
  }
}

class NotificationService {
  final SharedPreferencesService prefsService;
  final ApiService apiService;

  NotificationService(this.prefsService, this.apiService);

  // في ملف notification_service.dart

  Future<void> syncUserTopics({int maxRetries = 3}) async {
    int attempt = 0; // عداد المحاولات

    while (attempt < maxRetries) {
      try {
        final profile = await prefsService.getProfile();
        if (profile == null) return;

        final role = profile.userRole.trim();
          debugPrint("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy${role}");

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
            // await FirebaseMessaging.instance.subscribeToTopic(
            //   'campaign_${campaignId}_supervisors',
            // );
          }

          // معالجة قناة المجموعة للحاج والمشرف
          if (role == 'حاج' || role == 'مشرف') {
            int? savedGroupId = await prefsService.getInt('saved_group_id');

            if (currentGroupId != savedGroupId) {
              // 1. إلغاء الاشتراك من المجموعة القديمة (إن وجدت)
              if (savedGroupId != null) {
                String oldTopic = role == 'حاج'
                    ? 'campaign_${campaignId}_group_$savedGroupId'
                    : 'campaign_${campaignId}_supervisor_group_$savedGroupId';
                await FirebaseMessaging.instance.unsubscribeFromTopic(oldTopic);
              }
              // 2. الاشتراك في المجموعة الجديدة
              if (currentGroupId != null) {
                String newTopic = role == 'حاج'
                    ? 'campaign_${campaignId}_group_$currentGroupId'
                    : 'campaign_${campaignId}_supervisor_group_$currentGroupId';
                await FirebaseMessaging.instance.subscribeToTopic(newTopic);
                await prefsService.setInt('saved_group_id', currentGroupId);
              } else {
                await prefsService.removeInt('saved_group_id');
              }
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
      if (profile == null) return;

      int? savedGroupId = await prefsService.getInt('saved_group_id');
      if (savedGroupId != null) {
        // الطريقة الأسهل والأكثر أماناً عند تسجيل الخروج هي مسح التوكن بالكامل
        await FirebaseMessaging.instance.deleteToken();
      }
    } catch (e) {
      debugPrint("خطأ في حذف الاشتراكات: $e");
    }
  }
}
