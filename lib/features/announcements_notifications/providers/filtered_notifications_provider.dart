import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';
import 'package:yusr/features/announcements_notifications/providers/notifications_provider.dart';

part 'filtered_notifications_provider.g.dart';

@riverpod
class FilteredNotifications extends _$FilteredNotifications {
  // متغير داخلي لحفظ نص البحث
  String _searchQuery = '';

  @override
  AsyncValue<List<NotificationModel>> build() {
    // 1. نراقب الإعلانات الأصلية القادمة من السيرفر
    final notificationsState = ref.watch(notificationsProvider);

    // 2. نطبق الفلترة ونرجع النتيجة النهائية مباشرة
    return notificationsState.whenData((list) {
      if (_searchQuery.isEmpty) return list;

      return list.where((notification) {
        final title = notification.title.toLowerCase();
        final body = notification.body.toLowerCase();
        return title.contains(_searchQuery) || body.contains(_searchQuery);
      }).toList();
    });
  }

  // دالة لتحديث نص البحث وإعادة بناء القائمة
  void search(String query) {
    _searchQuery = query.trim().toLowerCase();
    ref.invalidateSelf();
  }

  // Getter بسيط لجلب النص الحالي
  String get searchQuery => _searchQuery;
}
