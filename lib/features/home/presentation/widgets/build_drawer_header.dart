import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

class BuildDrawerHeader extends StatelessWidget {
  const BuildDrawerHeader({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final bool showBadge =
        profile.userRole.contains('مشرف') || profile.userRole.contains('مدير');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        color: AppColor.golden,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoute.profileView);
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), 
                        blurRadius: 10, 
                        spreadRadius: 1, 
                        offset: const Offset(0, 4), 
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0xFF1A1A1A),
                    child: Text(
                      profile.fullName.isNotEmpty
                          ? profile.fullName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        color: AppColor.golden,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, 
                  left: 0, 
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColor.golden, 
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1A1A1A), 
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Text(
            profile.fullName,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            // _getRoleDisplayName(profile.userRole), // تحويل كود الدور لاسم ظاهر
            profile.userRole,
            style: const TextStyle(color: AppColor.baseFontColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}