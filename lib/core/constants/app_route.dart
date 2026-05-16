import 'package:flutter/material.dart';

// 1. استيراد موديلات البيانات (Models)
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';
import 'package:yusr/features/be_leader/presentation/views/leader_map_tracking_view.dart';
import 'package:yusr/features/be_leader/presentation/views/leader_pilgrims_list_view.dart';
import 'package:yusr/features/be_leader/presentation/views/leader_start_session_view.dart';
import 'package:yusr/features/be_leader/presentation/views/pilgrim_map_tracking_view.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart'
    show NotificationModel;
import 'package:yusr/features/announcements_notifications/presentation/views/add_announcement_view.dart';
import 'package:yusr/features/announcements_notifications/presentation/views/announcement_details_view.dart';
import 'package:yusr/features/announcements_notifications/presentation/views/announcements_view.dart';
import 'package:yusr/features/announcements_notifications/presentation/views/notification_details_view.dart'
    show NotificationDetailsView;
import 'package:yusr/features/announcements_notifications/presentation/views/notifications_view.dart'
    show NotificationsView;
import 'package:yusr/features/auth/presentation/views/account_verification.dart';
import 'package:yusr/features/auth/presentation/views/forgot_password.dart';
import 'package:yusr/features/auth/presentation/views/login_view.dart';
import 'package:yusr/features/auth/presentation/views/reset_password_view.dart';
import 'package:yusr/features/home/presentation/views/main_home_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/campaign_location_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/add_location_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/edit_location_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/set_location_view.dart';
import 'package:yusr/features/instructions/data/models/hajj_action_model.dart';
import 'package:yusr/features/instructions/presentation/views/action_details_view.dart';
import 'package:yusr/features/instructions/presentation/views/hajj_details_view.dart';
import 'package:yusr/features/instructions/presentation/views/instructions_view.dart';

import 'package:yusr/features/return_to_compaign_location/presentation/views/return_me_map_view.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/views/return_me_view.dart';
import 'package:yusr/features/profile/presentation/views/profile_view.dart';
import 'package:yusr/features/profile/presentation/views/saudi_phone_view.dart';
import 'package:yusr/features/group/presentation/views/group_info_view.dart';
import 'package:yusr/features/group/presentation/views/supervisor_group_view.dart';
import 'package:yusr/features/group/presentation/views/pilgrim_details_view.dart';
import 'package:yusr/features/campaign_management/presentation/views/campaign_info_view.dart';
import 'package:yusr/features/campaign_management/presentation/views/campaign_groups_view.dart';
import 'package:yusr/features/campaign_management/presentation/views/campaign_group_details_view.dart';
import 'package:yusr/features/campaign_management/presentation/views/campaign_pilgrim_details_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.mainHomeView:
        return MaterialPageRoute(builder: (_) => const MainHomeView());
      case AppRoute.loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoute.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case AppRoute.otpVerificationView:
        return MaterialPageRoute(builder: (_) => const OtpVerificationView());
      case AppRoute.resetPasswordView:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());
      case AppRoute.profileView:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case AppRoute.announcementsView:
        return MaterialPageRoute(builder: (_) => const AnnouncementsView());
      case AppRoute.addAnnouncementView:
        return MaterialPageRoute(builder: (_) => const AddAnnouncementView());
      case AppRoute.announcementDetailsView:
        final announcement = settings.arguments as AnnouncementModel;
        return MaterialPageRoute(
          builder: (_) => AnnouncementDetailsView(announcement: announcement),
        );
      case AppRoute.notificationsView:
        return MaterialPageRoute(builder: (_) => const NotificationsView());
      case AppRoute.notificationDetailsView:
        final notification = settings.arguments as NotificationModel;
        return MaterialPageRoute(
          builder: (_) => NotificationDetailsView(notification: notification),
        );
      case AppRoute.returnMeMapView:
        return MaterialPageRoute(builder: (_) => const ReturnMeMapView());
      case AppRoute.returnMeView:
        return MaterialPageRoute(builder: (_) => const ReturnMeView());
      case AppRoute.campaignLocationView:
        return MaterialPageRoute(builder: (_) => const CampaignLocationView());
      case AppRoute.addLocationView:
        return MaterialPageRoute(builder: (_) => const AddLocationView());
      case AppRoute.editLocationView:
        final location = settings.arguments as CampaignLocationItemModel;
        return MaterialPageRoute(
          builder: (_) => EditLocationView(location: location),
        );
      case AppRoute.setLocationView:
        return MaterialPageRoute(builder: (_) => const SetLocationView());
      case AppRoute.leaderStartSessionView:
        return MaterialPageRoute(builder: (_) => LeaderStartSessionView());
      case AppRoute.leaderPilgrimsListView:
        final int sessionId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LeaderPilgrimsListView(sessionId: sessionId),
        );
      case AppRoute.leaderMapTrackingView:
        final int sessionId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LeaderMapTrackingView(
            sessionId: sessionId, // 🚨 تمرير الرقم للواجهة هنا
          ),
        );
      case AppRoute.pilgrimMapTrackingView:
        final int sessionId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PilgrimMapTrackingView(sessionId: sessionId),
        );
      // case AppRoute.tawafCounterView:
      //   return MaterialPageRoute(builder: (_) => const TawafCounterView());
       case AppRoute.instructionsView:
        return MaterialPageRoute(builder: (_) => const InstructionsView());
      case AppRoute.hajjDetailsView:
        final hajjType = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HajjDetailsView(hajjType: hajjType),
        );
      case AppRoute.actionDetailsView:
        final action = settings.arguments as HajjActionModel;
        return MaterialPageRoute(
          builder: (_) => ActionDetailsView(action: action),
        );
      case AppRoute.addSaudiNumber:
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>? ?? {};
        final bool isEditMode = args['isEditMode'] as bool? ?? false;
        final String? currentNumber = args['currentNumber'] as String?;
        return MaterialPageRoute(
          builder: (_) => SaudiPhoneView(isEditMode: isEditMode, currentNumber: currentNumber),
        );
      case AppRoute.groupInfoView:
        return MaterialPageRoute(builder: (_) => const GroupInfoView());
      case AppRoute.supervisorGroupView:
        return MaterialPageRoute(builder: (_) => const SupervisorGroupView());
      case AppRoute.pilgrimDetailsView:
        final userId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PilgrimDetailsView(userId: userId),
        );
      case AppRoute.campaignInfoView:
        return MaterialPageRoute(builder: (_) => const CampaignInfoView());
      case AppRoute.campaignGroupsView:
        return MaterialPageRoute(builder: (_) => const CampaignGroupsView());
      case AppRoute.campaignGroupDetailsView:
        final groupId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CampaignGroupDetailsView(groupId: groupId),
        );
      // case AppRoute.campaignPilgrimsView:
      //   return MaterialPageRoute(builder: (_) => const CampaignPilgrimsView());
      case AppRoute.campaignPilgrimDetailsView:
        final userId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CampaignPilgrimDetailsView(userId: userId),
        );
      // case AppRoute.campaignSupervisorsView:
      //   return MaterialPageRoute(builder: (_) => const CampaignSupervisorsView());
      // case AppRoute.campaignSupervisorDetailsView:
      //   final userId = settings.arguments as int;
      //   return MaterialPageRoute(
      //     builder: (_) => CampaignSupervisorDetailsView(userId: userId),
      //   );
      default:
        return null;
    }
  }
}

class AppRoute {
  static const String mainHomeView = '/MainHomeView';
  static const String loginView = '/loginView';
  static const String forgotPassword = '/ForgotPassword';
  static const String otpVerificationView = '/OtpVerificationView';
  static const String resetPasswordView = '/ResetPasswordView';
  static const String announcementsView = '/AnnouncementsView';
  static const String addAnnouncementView = '/AddAnnouncementView';

  static const String campaignLocationView = '/CampaignLocationView';
  static const String addLocationView = '/AddLocationView';
  static const String editLocationView = '/EditLocationView';
  static const String setLocationView = '/SetLocationView';
  static const String announcementDetailsView = '/AnnouncementDetailsView';
  static const String notificationsView = '/NotificationsView';
  static const String notificationDetailsView = '/NotificationDetailsView';

  static const String returnMeMapView = '/ReturnMeMapView';
  static const String returnMeView = '/ReturnMeView';
  static const String leaderPilgrimsListView = '/LeaderPilgrimsListView';
  static const String leaderMapTrackingView = '/LeaderMapTrackingView';
  static const String leaderStartSessionView = '/LeaderStartSessionView';
  static const String pilgrimMapTrackingView = '/PilgrimMapTrackingView';
  static const String tawafCounterView = '/TawafCounterView';
  static const String instructionsView = '/InstructionsView';
  static const String hajjDetailsView = '/HajjDetailsView';
  static const String actionDetailsView = '/ActionDetailsView';
  static const String profileView = '/ProfileView';
  static const String addSaudiNumber = '/AddSaudiNumber';
  static const String groupInfoView = '/GroupInfoView';
  static const String supervisorGroupView = '/SupervisorGroupView';
  static const String pilgrimDetailsView = '/PilgrimDetailsView';
  
  // Campaign Management (مدير الحملة)
  static const String campaignInfoView = '/CampaignInfoView';
  static const String campaignGroupsView = '/CampaignGroupsView';
  static const String campaignGroupDetailsView = '/CampaignGroupDetailsView';
  // static const String campaignPilgrimsView = '/CampaignPilgrimsView';
  static const String campaignPilgrimDetailsView = '/CampaignPilgrimDetailsView';
  // static const String campaignSupervisorsView = '/CampaignSupervisorsView';
  // static const String campaignSupervisorDetailsView = '/CampaignSupervisorDetailsView';
}
