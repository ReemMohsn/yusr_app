enum TargetAudience {
  all(1, 'الكل'),
  pilgrims(2, 'الحجاج'),
  supervisors(3, 'المشرفين'),
  groupPilgrims(4, 'حجاج القروب');

  final int id;
  final String name;
  const TargetAudience(this.id, this.name);
}
