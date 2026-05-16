enum TrackingType { tawaf, saee }

class AutoCounterState {
  final int currentLap;

  final int totalLaps;

  final bool isRunning;

  final bool isCompleted;

  final int stepsInCurrentLap;

  final double accumulatedAngle;

  final bool isMoving;

  final TrackingType trackingType;

  final double startHeading;

  final bool turnDetected;

  final String? permissionError;

  const AutoCounterState({
    this.currentLap = 1,
    this.totalLaps = 7,
    this.isRunning = false,
    this.isCompleted = false,
    this.stepsInCurrentLap = 0,
    this.accumulatedAngle = 0.0,
    this.isMoving = false,
    this.trackingType = TrackingType.tawaf,
    this.startHeading = -1.0,
    this.turnDetected = false,
    this.permissionError,
  });

  int get remainingLaps => (totalLaps - currentLap) + 1;

  AutoCounterState copyWith({
    int? currentLap,
    int? totalLaps,
    bool? isRunning,
    bool? isCompleted,
    int? stepsInCurrentLap,
    double? accumulatedAngle,
    bool? isMoving,
    TrackingType? trackingType,
    double? startHeading,
    bool? turnDetected,
    String? permissionError,
  }) {
    return AutoCounterState(
      currentLap: currentLap ?? this.currentLap,
      totalLaps: totalLaps ?? this.totalLaps,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
      stepsInCurrentLap: stepsInCurrentLap ?? this.stepsInCurrentLap,
      accumulatedAngle: accumulatedAngle ?? this.accumulatedAngle,
      isMoving: isMoving ?? this.isMoving,
      trackingType: trackingType ?? this.trackingType,
      startHeading: startHeading ?? this.startHeading,
      turnDetected: turnDetected ?? this.turnDetected,
      permissionError: permissionError ?? this.permissionError,
    );
  }

  @override
  String toString() =>
      'AutoCounterState('
      'Lap:$currentLap '
      'Moving:$isMoving '
      'Steps:$stepsInCurrentLap '
      'Angle:${accumulatedAngle.toStringAsFixed(1)} '
      'Turn:$turnDetected'
      ')';
}
