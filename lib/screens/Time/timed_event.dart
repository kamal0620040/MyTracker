class TimedEvent {
  final String id;
  final String title;
  final String time;
  final bool active;
  final String startTime;
  final String startTimePause;
  final String categoryTime;
  final String timeDesc;
  bool isFavorite = false;
  TimedEvent({
    required this.id,
    required this.active,
    required this.startTime,
    required this.startTimePause,
    required this.title,
    required this.time,
    required this.categoryTime,
    required this.timeDesc,
    this.isFavorite = false,
  });

  TimedEvent copyWith({
    String? newTitle,
    bool? newActive,
    String? newTime,
    String? newStartTime,
    String? newStartTimePause,
    String? newCategoryTime,
    String? newTimeDesc,
    bool? newIsFavorite,
  }) {
    return TimedEvent(
        id: id,
        title: newTitle ?? title,
        time: newTime ?? time,
        active: newActive ?? active,
        startTime: newStartTime ?? startTime,
        startTimePause: newStartTimePause ?? startTimePause,
        categoryTime: newCategoryTime ?? categoryTime,
        timeDesc: newTimeDesc ?? timeDesc,
        isFavorite: newIsFavorite ?? isFavorite);
  }
}
