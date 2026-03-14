import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_provider.dart';

part 'filtered_announcements_provider.g.dart';

@riverpod
class FilteredAnnouncements extends _$FilteredAnnouncements {
  // متغير داخلي لحفظ نص البحث
  String _searchQuery = '';

  @override
  AsyncValue<List<AnnouncementModel>> build() {
    // 1. نراقب الإعلانات الأصلية القادمة من السيرفر
    final announcementsState = ref.watch(announcementsProvider);

    // 2. نطبق الفلترة ونرجع النتيجة النهائية مباشرة
    return announcementsState.whenData((list) {
      if (_searchQuery.isEmpty) return list;

      return list.where((announcement) {
        final title = announcement.title.toLowerCase();
        final body = announcement.body.toLowerCase();
        return title.contains(_searchQuery) || body.contains(_searchQuery);
      }).toList();
    });
  }

  // دالة لتحديث نص البحث وإعادة بناء القائمة
  void search(String query) {
    _searchQuery = query.trim().toLowerCase();
    // Invalidate تجعل الرفربود يعيد تشغيل دالة build لتطبيق الفلترة الجديدة
    ref.invalidateSelf();
  }

  // Getter بسيط لجلب النص الحالي (نحتاجه في الواجهة لمعرفة هل نظهر زر X)
  String get searchQuery => _searchQuery;
}
