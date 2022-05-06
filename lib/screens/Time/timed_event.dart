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

  static Map<String, dynamic> toMap(TimedEvent event) => {
        'id': event.id,
        'title': event.title,
        'time': event.time,
        'active': event.active,
        'startTime': event.startTime,
        'startTimePause': event.startTimePause,
        'categoryTime': event.categoryTime,
        'timeDesc': event.timeDesc,
        'isFavorite': event.isFavorite,
      };

  factory TimedEvent.fromJson(jsonData) {
    return TimedEvent(
        id: jsonData['id'],
        active: jsonData['active'],
        startTime: jsonData['startTime'],
        startTimePause: jsonData['startTimePause'],
        title: jsonData['title'],
        time: jsonData['time'],
        categoryTime: jsonData['categoryTime'],
        timeDesc: jsonData['timeDesc'],
        isFavorite: jsonData['isFavorite']);
  }

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
