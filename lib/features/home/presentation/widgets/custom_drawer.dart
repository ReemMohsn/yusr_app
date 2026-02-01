// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomDrawer extends ConsumerWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final role = ref.watch(userRoleProvider); // نستمع للدور

//     return Drawer(
//       child: Column(
//         children: [
//           _buildHeader(ref), // الهيدر (صورة واسم)
//           Expanded(
//             child: ListView(
//               children: _getMenuItemsForRole(role), // دالة تجلب العناصر حسب الدور
//             ),
//           ),
//           _buildLogoutButton(ref),
//         ],
//       ),
//     );
//   }

//   // هذه الدالة هي "المخ" الذي يقرر ماذا يظهر
//   List<Widget> _getMenuItemsForRole(UserRole role) {
//     switch (role) {
//       case UserRole.pilgrim:
//         return [
//           _buildTile(Icons.info, "معلومات القروب"),
//           _buildTile(Icons.book, "مناسك الحج"),
//         ];
//       case UserRole.supervisor:
//         return [
//           _buildTile(Icons.star, "كن قائد"),
//           _buildTile(Icons.campaign, "الإعلانات"),
//           _buildTile(Icons.group, "معلومات القروب"),
//           _buildTile(Icons.book, "مناسك الحج"),
//         ];
//       case UserRole.manager:
//         return [
//            _buildTile(Icons.campaign, "الإعلانات"),
//            _buildTile(Icons.location_on, "موقع استقرار الحملة"),
//            _buildTile(Icons.book, "مناسك الحج"),
//         ];
//       case UserRole.guest:
//       default:
//         return [
//            _buildTile(Icons.login, "تسجيل الدخول"),
//         ];
//     }
//   }

//   Widget _buildTile(IconData icon, String title) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.amber), // لون الثيم الخاص بك
//       title: Text(title, style: TextStyle(color: Colors.white)),
//       onTap: () {},
//     );
//   }
  
//   // ... بقية الودجت للهيدر وزر الخروج
//    Widget _buildHeader(WidgetRef ref) { /* ... */ return Container(); }
//    Widget _buildLogoutButton(WidgetRef ref) { /* ... */ return Container(); }
// }