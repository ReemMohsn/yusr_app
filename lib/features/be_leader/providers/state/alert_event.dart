class AlertEvent {
  final String pilgrimId;
  final String pilgrimName;
  final String alertType; // 'yellow' للتحذير، 'red' للإنذار
  final DateTime timestamp; // مهم جداً لكي يعتبره Riverpod حدثاً جديداً دائماً

  AlertEvent({
    required this.pilgrimId,
    required this.pilgrimName,
    required this.alertType,
    required this.timestamp,
  });
}
