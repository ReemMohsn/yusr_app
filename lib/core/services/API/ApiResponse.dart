class ApiResponse<T> {
  final T? data; // هنا سيكون الـ ProfileModel أو أي مودل آخر
  final String message; // رسالة النجاح القادمة من الباك إند

  ApiResponse({required this.data, required this.message});
}
