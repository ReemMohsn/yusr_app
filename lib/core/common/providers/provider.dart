// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:yusr/core/common/enums/user_role.dart';

// // هذا مجرد مثال، لاحقاً سيأتي من الـ API أو الـ SharedPref
// final currentUserProvider = StateProvider<UserModel?>((ref) {
//   return null; // مبدئياً هو null يعني زائر (Guest)
// });

// // Provider مشتق يسهل علينا معرفة الدور الحالي
// final userRoleProvider = Provider<UserRole>((ref) {
//   final user = ref.watch(currentUserProvider);
//   return user?.role ?? UserRole.guest;
// });
