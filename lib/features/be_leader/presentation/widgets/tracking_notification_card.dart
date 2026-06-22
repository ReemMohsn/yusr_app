import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/data/models/tracking_notification_model.dart';
import 'package:yusr/features/be_leader/presentation/widgets/tracking_session_dialog.dart';
import 'package:yusr/features/be_leader/providers/active_session_id_provider.dart';

/// بطاقة عرض إشعار "كن قائد" (تحذير، إنذار، دعوة جلسة، تغيّر حالة).

class TrackingNotificationCard extends ConsumerWidget {
  final TrackingNotificationModel notification;

  const TrackingNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    // ─── ألوان البطاقة ───
    final Color cardColor;
    final Color borderColor;
    final IconData icon;

    switch (notification.type) {
      case TrackingNotificationType.sessionInvite:
        cardColor = const Color(0xFFFFF8E1);
        borderColor = Colors.amber.shade600;
        icon = Icons.location_on;
        break;
      case TrackingNotificationType.pilgrimWarning:
      case TrackingNotificationType.leaderWarning:
        cardColor = const Color(0xFFFFF9C4);
        borderColor = Colors.orange.shade600;
        icon = Icons.warning_amber_rounded;
        break;
      case TrackingNotificationType.pilgrimEmergency:
      case TrackingNotificationType.leaderEmergency:
        cardColor = const Color(0xFFFFEBEE);
        borderColor = Colors.red.shade600;
        icon = Icons.emergency;
        break;
      case TrackingNotificationType.statusChange:
        cardColor = const Color(0xFFE8F5E9);
        borderColor = Colors.green.shade600;
        icon = Icons.people_alt;
        break;
    }

    // ─── وقت وتاريخ ───
    final ts = DateTime.tryParse(notification.timestamp);
    final timeStr = ts != null
        ? '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}'
        : '';
    final dateStr = ts != null ? '${ts.day}/${ts.month}/${ts.year}' : '';

    // ─── هل هذه دعوة جلسة؟ ───
    final isSessionInvite =
        notification.type == TrackingNotificationType.sessionInvite &&
        notification.sessionId != null;

    // ─── هل الحاج يتتبع في نفس الجلسة؟ (يتغير تفاعلياً) ───
    final activeSessionId = ref.watch(activeSessionIdProvider);
    final isCurrentlyTracking =
        isSessionInvite && activeSessionId == notification.sessionId;

    // ─── فتح الدايلوج الموحّد ───
    void openDialog() {
      if (!isSessionInvite || isCurrentlyTracking) return;
      TrackingSessionDialog.show(
        context,
        sessionId: notification.sessionId!,
        notificationBody: notification.body,
      );
    }

    return GestureDetector(
      onTap: isSessionInvite ? openDialog : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── رأس ───
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: borderColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: borderColor, size: 20.sp),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    timeStr,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // ─── الجسم ───
              Text(
                notification.body,
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              ),
              SizedBox(height: 10.h),
              // ─── تذييل ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13.sp,
                        color: Colors.black38,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  // ─── منطقة الزر الذكية (للدعوة فقط) ───
                  if (isSessionInvite)
                    isCurrentlyTracking
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.shade400,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.my_location,
                                  size: 14.sp,
                                  color: Colors.green.shade700,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  locale.trackingInProgress,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: openDialog,
                            icon: const Icon(
                              Icons.login,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              locale.join,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.golden,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
