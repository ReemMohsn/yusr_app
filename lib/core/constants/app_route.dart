import 'package:flutter/material.dart';

// 1. استيراد موديلات البيانات (Models)
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart' show NotificationModel;
import 'package:yusr/features/announcements_notifications/presentation/views/add_announcement_view.dart';
import 'package:yusr/features/announcements_notifications/presentation/views/announcement_details_view.dart';
import 'package:yusr/features/announcements_notifications/presentation/views/announcements_view.dart';
import 'package:yusr/features/announcements_notifications/presentation/views/notification_details_view.dart' show NotificationDetailsView;
import 'package:yusr/features/announcements_notifications/presentation/views/notifications_view.dart' show NotificationsView;
import 'package:yusr/features/auth/presentation/views/account_verification.dart';
import 'package:yusr/features/auth/presentation/views/forgot_password.dart';
import 'package:yusr/features/auth/presentation/views/login_view.dart';
import 'package:yusr/features/auth/presentation/views/reset_password_view.dart';
import 'package:yusr/features/home/presentation/views/main_home_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/campaign_location_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/add_location_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/edit_location_view.dart';
import 'package:yusr/features/campaign_location/presentation/views/set_location_view.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/views/return_me_map_view.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/views/return_me_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class AppRoute {
//   static const String mainHomeView = '/MainHomeView';
//   static const String loginView = '/loginView';
//   static const String forgotPassword = '/ForgotPassword';
//   static const String otpVerificationView = '/OtpVerificationView';
//   static const String resetPasswordView = '/ResetPasswordView';
//   static const String announcementsView = '/AnnouncementsView';
//   static const String addAnnouncementView = '/AddAnnouncementView';
//   static const String announcementDetailsView = '/AnnouncementDetailsView';
//   static const String returnMeMapView = '/ReturnMeMapView';
//   static const String returnMeView = '/ReturnMeView';

// }

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
        final notification = settings.arguments as NotificationModel; // تأكد من نوع البيانات إذا لزم الأمر
        // هنا يمكنك تمرير بيانات الإشعار إذا لزم الأمر
        return MaterialPageRoute(builder: (_) =>  NotificationDetailsView(notification: notification));  
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
}
