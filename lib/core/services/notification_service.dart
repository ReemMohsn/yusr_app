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

  Future<void> syncUserTopics() async {
    try {
      // 1. جلب بيانات المستخدم المحفوظة
      final profile = await prefsService.getProfile();

      // إذا كان زائر (Guest)، نوقف الدالة فوراً
      if (profile == null) return;

      final role = profile.userRole.trim();

      // 2. إذا كان مدير حملة، لا نريد أن نستهلك موارد السيرفر لأنه لا يستقبل إشعارات
      if (role == 'مدير الحملة') {
        debugPrint(
          "المستخدم مدير حملة: تم تخطي مزامنة الإشعارات لتوفير الموارد.",
        );
        return;
      }

      // 3. استدعاء API المزامنة للحاج والمشرف فقط
      final response = await repositoryRequestHandler<SyncDataModel>(
        () => apiService.get(ApiLink.syncData),
        fromJson: (data) => SyncDataModel.fromJson(data),
      );

      final syncData = response.data;

      if (syncData != null) {
        int campaignId = syncData.campaignId;
        int? currentGroupId = syncData.groupId;

        // 4. الاشتراك في القنوات العامة بناءً على الدور
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

        // ==========================================
        // 5. معالجة قناة المجموعة (للحجاج فققققط!)
        // ==========================================
        if (role == 'حاج') {
          int? savedGroupId = await prefsService.getInt('saved_group_id');

          if (currentGroupId != savedGroupId) {
            // إلغاء القديم
            if (savedGroupId != null) {
              await FirebaseMessaging.instance.unsubscribeFromTopic(
                'campaign_${campaignId}_group_$savedGroupId',
              );
            }
            // الاشتراك في الجديد
            if (currentGroupId != null) {
              await FirebaseMessaging.instance.subscribeToTopic(
                'campaign_${campaignId}_group_$currentGroupId',
              );
              await prefsService.setInt('saved_group_id', currentGroupId);
            } else {
              // طُرد الحاج من المجموعة
              await prefsService.removeInt('saved_group_id');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('حدث خطأ أثناء مزامنة الإشعارات: $e');
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
