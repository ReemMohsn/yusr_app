// class MuftiResponseModel {
//   final String answer;
//   final String confidence;

//   MuftiResponseModel({required this.answer, required this.confidence});

//   factory MuftiResponseModel.fromJson(Map<String, dynamic> json) {
//     return MuftiResponseModel(
//       answer: json['answer'] ?? 'لا توجد إجابة',
//       confidence: json['confidence'] ?? '0%',
//     );
//   }
// }
class MuftiResponseModel {
  final String answer;
  final String confidence;

  MuftiResponseModel({required this.answer, required this.confidence});

  factory MuftiResponseModel.fromJson(Map<String, dynamic> json) {
    return MuftiResponseModel(
      // تأكدي من تحويل القيمة لـ String واستخدام الـ trim
      answer: (json['answer']?.toString() ?? 'لا توجد إجابة').trim(),
      confidence: json['confidence']?.toString() ?? '0%',
    );
  }
}
// class MuftiResponseModel {
//   final String answer;
//   final String confidence;
//   final String reference; // إضافة حقل المصدر

//   MuftiResponseModel({
//     required this.answer,
//     required this.confidence,
//     required this.reference,
//   });

//   factory MuftiResponseModel.fromJson(Map<String, dynamic> json) {
//     return MuftiResponseModel(
//       answer: (json['answer']?.toString() ?? 'لا توجد إجابة').trim(),
//       confidence: json['confidence']?.toString() ?? '0%',
//       reference: json['reference']?.toString() ?? 'قاعدة بيانات يُسر للفتاوى',
//     );
//   }
// }