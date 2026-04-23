import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import '../data/repositories/mufti_repository.dart';

// تأكدي أن هذا السطر يطابق اسم الملف الحالي بالضبط
part 'mufti_repository_provider.g.dart'; 

@riverpod
MuftiRepository muftiRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MuftiRepository(apiService, ref);
}