import 'package:cloud_firestore/cloud_firestore.dart';

class PostTime {
  final String id;
  final String title;
  final String time;
  final bool active;
  final String startTime;
  final String startTimePause;
  final String categoryTime;
  final String timeDesc;
  bool isFavorite = false;

  PostTime({
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "time": time,
        "active": active,
        "startTime": startTime,
        "startTimePause": startTimePause,
        "categoryTime": categoryTime,
        "timeDesc": timeDesc,
        "isFavorite": isFavorite,
      };

  static PostTime fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostTime(
      id: snapshot['id'],
      title: snapshot['title'],
      time: snapshot['time'],
      active: snapshot['active'],
      startTime: snapshot['startTime'],
      startTimePause: snapshot['startTimePause'],
      categoryTime: snapshot['categoryTime'],
      timeDesc: snapshot['timeDesc'],
      isFavorite: snapshot['isFavorite'],
    );
  }
}
