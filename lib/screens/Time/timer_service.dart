import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'timed_event.dart';
import 'helpers.dart';
import 'package:mytracker/resources/firestore_methods.dart';

class TimerServices with ChangeNotifier {
  List<TimedEvent> firefetch = [];
  int timerone = 1;
  int initialloadtimer = 1;
  List<TimedEvent> _timedEvents = [];
  String selectedCat = '';
  List<TimedEvent> get timedEvents {
    return _timedEvents
        .where((element) => element.categoryTime == selectedCat)
        .toList()
        .reversed
        .toList();
  }

  List<TimedEvent> get timedEventsFav {
    return _timedEvents
        .where((element) =>
            element.categoryTime == selectedCat && element.isFavorite)
        .toList()
        .reversed
        .toList();
  }

  List<TimedEvent> get timedEventsAll {
    return _timedEvents;
  }

  Timer? timer;
  bool get timerActive => _timedEvents.any((element) => element.active);
  TimedEvent get activeEvent =>
      _timedEvents.firstWhere((element) => element.active);

  int _seconds = 0;

  String get currentTime {
    Duration current = Duration(seconds: _seconds);
    String hours = padNumber(current.inHours);
    String minutes = padNumber(current.inMinutes.remainder(60));
    String seconds = padNumber(current.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  TimerServices();

  void load(String catId, String uid) async {
    firefetch = [];

    selectedCat = catId;

    final collRef = await FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .get();
    collRef.docs.forEach((e) {
      firefetch.add(TimedEvent(
          id: e['id'],
          active: e['active'],
          startTime: e['startTime'],
          startTimePause: e['startTimePause'],
          title: e['title'],
          time: e['time'],
          categoryTime: e['categoryTime'],
          timeDesc: e['timeDesc'],
          isFavorite: e['isFavorite']));
    });
    _timedEvents = firefetch;

    if (timerActive) {
      if (initialloadtimer == 1) {
        timerone = 1;
        initialloadtimer++;
      } else {
        timerone++;
      }
      if (timerone == 1) {
        DateTime startTimePause = DateTime.parse(activeEvent.startTimePause);

        int helper = int.parse(activeEvent.time.substring(0, 2)) * 3600 +
            int.parse(activeEvent.time.substring(3, 5)) * 60 +
            int.parse(activeEvent.time.substring(6, 8));
        _seconds = helper + DateTime.now().difference(startTimePause).inSeconds;

        startTimer();
      }
    }
    notifyListeners();
  }

  void addNew(String catId, BuildContext context, String uid) async {
    if (timerActive) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text(
          'Another timer is currently active!!',
          style: TextStyle(fontSize: 16),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    initialloadtimer++;
    DateTime startTime = DateTime.now();
    TimedEvent newEvent = TimedEvent(
        id: uid,
        title: 'New Event',
        time: '00:00:00',
        active: true,
        startTime: startTime.toIso8601String(),
        startTimePause: startTime.toIso8601String(),
        categoryTime: catId,
        timeDesc: 'Description.....');

    String res = await FireStoreMethods().uploadTime(
        uid,
        newEvent.title,
        newEvent.time,
        newEvent.active,
        newEvent.startTime,
        newEvent.startTimePause,
        newEvent.categoryTime,
        newEvent.timeDesc,
        newEvent.isFavorite);
    if (res == "success") {
      print("Uploaded");
    } else {
      print("Errrrrrrrrrrrrrorrr");
    }
    _timedEvents.add(newEvent);
    notifyListeners();
    _seconds = 0;
    startTimer();
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: const Text(
        'New Timer Posted',
        style: TextStyle(fontSize: 16),
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    load(catId, uid);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    return;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds += 1;
      notifyListeners();
    });
  }

  void stop(String id, String uid) {
    if (timer != null && !timer!.isActive) return;

    timer!.cancel();

    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .doc(t)
        .update({'active': false, 'time': currentTime});

    TimedEvent event = activeEvent.copyWith(
      newActive: false,
      newTime: currentTime,
    );
    int currentIndex = _timedEvents.indexWhere((element) => element.active);
    _timedEvents[currentIndex] = event;
    notifyListeners();
  }

  void delete(String idm, String uid) {
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == idm;
    }).id;

    FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .doc(t)
        .delete();
    _timedEvents
        .removeWhere((element) => element.id == t && element.active == false);

    // .removeWhere((element) => element.id == id);
    // _timedEvents = [];
    notifyListeners();
  }

  void edit(String id, String title, String uid) {
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .doc(t)
        .update({'title': title});

    TimedEvent updatedEvent = _timedEvents
        .firstWhere((element) => element.id == t)
        .copyWith(newTitle: title);
    int index = _timedEvents.indexWhere((element) => element.id == t);
    _timedEvents[index] = updatedEvent;
    notifyListeners();
  }

  void editDesc(String id, String description, String uid) {
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .doc(t)
        .update({'timeDesc': description});

    TimedEvent updatedEvent = _timedEvents
        .firstWhere((element) => element.id == t)
        .copyWith(newTimeDesc: description);
    int index = _timedEvents.indexWhere((element) => element.id == t);
    _timedEvents[index] = updatedEvent;

    notifyListeners();
  }

  void editFav(String id, String uid) {
    bool t = false;

    String? tm = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;

    TimedEvent updatedEvent = _timedEvents.firstWhere((element) {
      t = !element.isFavorite;
      return element.id == tm;
    }).copyWith(newIsFavorite: t);
    int index = _timedEvents.indexWhere((element) => element.id == tm);
    _timedEvents[index] = updatedEvent;

    FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .doc(tm)
        .update({'isFavorite': t});
    notifyListeners();
  }

  void editTime(String id, String time, BuildContext context, String uid) {
    if (timerActive) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text(
          'Another timer is currently active!!',
          style: TextStyle(fontSize: 16),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }
    String startTime = DateTime.now().toString();
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    FirebaseFirestore.instance
        .collection("timePost")
        .doc(uid)
        .collection("Time")
        .doc(t)
        .update({'active': true, 'time': time, 'startTimePause': startTime});

    initialloadtimer++;

    TimedEvent updatedEvent =
        _timedEvents.firstWhere((element) => element.id == t).copyWith(
              newTime: time,
              newActive: true,
              newStartTimePause: startTime,
            );
    int index = _timedEvents.indexWhere((element) => element.id == t);
    _timedEvents[index] = updatedEvent;
    notifyListeners();
    _seconds = int.parse(time.substring(0, 2)) * 3600 +
        int.parse(time.substring(3, 5)) * 60 +
        int.parse(time.substring(6, 8));

    startTimer();
  }

  int timeToseconds(String time) {
    return int.parse(time.substring(0, 2)) * 3600 +
        int.parse(time.substring(3, 5)) * 60 +
        int.parse(time.substring(6, 8));
  }
}
