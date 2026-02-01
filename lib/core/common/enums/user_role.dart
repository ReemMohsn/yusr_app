enum UserRole {
  guest, // زائر (قبل تسجيل الدخول)
  pilgrim, // حاج
  supervisor, // مشرف
  manager, // مدير
}

// نموذج بسيط للمستخدم
class UserModel {
  final String name;
  final UserRole role;
  // ... other fields
  UserModel({required this.name, required this.role});
}
