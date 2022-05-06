import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timed_event.dart';
import 'helpers.dart';
import 'package:mytracker/resources/firestore_methods.dart';

class TimerServices with ChangeNotifier {
  int s = 0;
  List<TimedEvent> firefetch = [];
  List<TimedEvent> dum = [];
  int timerone = 1;
  int initialloadtimer = 1;
  List<TimedEvent> _timedEvents = [];
  String random = '';
  List<TimedEvent> test = [];
  List<TimedEvent> get timedEvents {
    return _timedEvents
        .where((element) => element.categoryTime == random)
        .toList()
        .reversed
        .toList();
  }

  List<TimedEvent> get timedEventsFav {
    return _timedEvents
        .where(
            (element) => element.categoryTime == random && element.isFavorite)
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

  TimerServices() {
    // void test() async {
    //   final collRef = await FirebaseFirestore.instance
    //       .collection("timePost")
    //       .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
    //       .collection("Time")
    //       .get();
    //   collRef.docs.forEach((e) {
    //     firefetch.add(TimedEvent(
    //         id: e['id'],
    //         active: e['active'],
    //         startTime: e['startTime'],
    //         startTimePause: e['startTimePause'],
    //         title: e['title'],
    //         time: e['time'],
    //         categoryTime: e['categoryTime'],
    //         timeDesc: e['timeDesc']));
    //   });
    // }

    // dum = firefetch;
    // test();
  }

  void save() {
    String data = jsonEncode(
        _timedEvents.map((event) => TimedEvent.toMap(event)).toList());
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('events', data);
    });
  }

  void load(String catId) {
    firefetch = [];
    // print(cat_id);
    // int s = int.parse(z);
    SharedPreferences.getInstance().then((prefs) async {
      if (prefs.containsKey('events')) {
        String data = prefs.getString('events')!;
        var x = jsonDecode(data);

        // _timedEvents =  jsonDecode(data)
        //     .map<TimedEvent>((item) => TimedEvent.fromJson(item))
        //     .toList();

        List<TimedEvent> z = x.map<TimedEvent>((item) {
          // if (x[0]['titlem'] == '1') {
          return TimedEvent.fromJson(item);
        }).toList();
        _timedEvents = z;
        random = catId;
        // test = _timedEvents;
        // print(z);
        // _timedEvents =
        //     z.where((element) => element.categoryTime == cat_id).toList();
        // print(x[0]['title'].runtimeType);
        // print(_timedEvents[0].title);
        // print(x);
        // if (timerActive) {
        //   DateTime startTime = DateTime.parse(activeEvent.startTime);
        //   _seconds = DateTime.now().difference(startTime).inSeconds;
        //   // s = (s + 1);

        //   startTimer(1);
        // }
        final collRef = await FirebaseFirestore.instance
            .collection("timePost")
            .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
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
              timeDesc: e['timeDesc']));
        });
        _timedEvents = firefetch;

        // print(_timedEvents[0].id);
        if (timerActive) {
          if (initialloadtimer == 1) {
            timerone = 1;
            initialloadtimer++;
          } else {
            timerone++;
          }
          if (timerone == 1) {
            // print('FUCK${activeEvent.time}');
            DateTime startTimePause =
                DateTime.parse(activeEvent.startTimePause);
            // _seconds = DateTime.now().difference(startTime).inSeconds;
            // _seconds = int.parse(activeEvent.time);
            // s = (s + 1);

            // print(activeEvent.startTime);
            // print(startTime);

            // print(wwe);
            // print(activeEvent.time);
            int helper = int.parse(activeEvent.time.substring(0, 2)) * 60 +
                int.parse(activeEvent.time.substring(3, 5)) * 60 +
                int.parse(activeEvent.time.substring(6, 8));
            // _seconds = helper + helpernow - helper;
            _seconds =
                helper + DateTime.now().difference(startTimePause).inSeconds;
            // print(helper);
            // print(activeEvent.time);
            // print(activeEvent.startTime);
            // print(activeEvent.startTimePause);
            // _seconds = helper;
            // DateTime.now().difference(startTime).inSeconds;

            startTimer();
            // delete('id');
          }
        }
        notifyListeners();
      }
    });
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
    // print(newEvent.id);
    startTimer();
    // print(newEvent.id);
    // print(newEvent.startTime);
    // void temp() async {
    // final collRef = await FirebaseFirestore.instance
    //     .collection("timePost")
    //     .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
    //     .collection("Time")
    //     .get();
    // collRef.docs.map((e) => {print(e.data())});
    // }
// ssssssssssssssssssssssssssssssssssssss
    // List<TimedEvent> temp = [];
    // List<TimedEvent> fuck = collRef.docs.map<TimedEvent>((item) {
    //   return TimedEvent.fromJson(item);
    // }).toList();

    // collRef.docs.forEach((e) {

    //   temp.add(e.data);
    // });
// ssssssssssssssssssssssssssssssssssssss
    // temp();
    // print(collRef.docs[0].data());
    // print(collRef.docs[0].data().runtimeType);
    // print(collRef.docs[0].data());
    // collRef.docs.forEach((e) {
    //   firefetch.add(TimedEvent(
    //       id: e['id'],
    //       active: e['active'],
    //       startTime: e['startTime'],
    //       startTimePause: e['startTimePause'],
    //       title: e['title'],
    //       time: e['time'],
    //       categoryTime: e['categoryTime'],
    //       timeDesc: e['timeDesc']));
    // });
    // print(collRef.docs[0]['title']);
    // print(collRef.docs[0]['startTime']);
    // print(collRef.docs[0]['id']);
    // print(collRef.docs[0]['active']);
    // print(collRef.docs[0]['startTimePause']);
    // print(collRef.docs[0]['time']);
    // print(collRef.docs[0]['categoryTime']);
    // print(collRef.docs[0]['timeDesc']);
    // print(_timedEvents);
    // print(firefetch);
    // _timedEvents = firefetch;
    // print(firefetch[0]);
    save();
    load(catId);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds += 1;
      notifyListeners();
    });
  }

  void stop(String id) {
    if (timer != null && !timer!.isActive) return;

    timer!.cancel();

    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    print(t);
    FirebaseFirestore.instance
        .collection("timePost")
        .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
        .collection("Time")
        .doc(t)
        .update({'active': false, 'time': currentTime});

    TimedEvent event = activeEvent.copyWith(
      newActive: false,
      newTime: currentTime,
    );
    int currentIndex = _timedEvents.indexWhere((element) => element.active);
    _timedEvents[currentIndex] = event;
    save();
    notifyListeners();
  }

  void delete(String idm) {
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == idm;
    }).id;
    print(t);
    print('ssssssssssssssss');
    print(_timedEvents[0].id);

    // print(FirebaseFirestore.instance
    //     .collection("timePost")
    //     .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
    //     .collection("Time")
    //     .doc()
    //     .get());
    // print(id);
    FirebaseFirestore.instance
        .collection("timePost")
        .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
        .collection("Time")
        .doc(t)
        .delete();
    _timedEvents
        .removeWhere((element) => element.id == t && element.active == false);
    // .removeWhere((element) => element.id == id);
    // _timedEvents = [];
    notifyListeners();
    save();
  }

  void edit(String id, String title) {
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    print(t);
    FirebaseFirestore.instance
        .collection("timePost")
        .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
        .collection("Time")
        .doc(t)
        .update({'title': title});

    TimedEvent updatedEvent = _timedEvents
        .firstWhere((element) => element.id == t)
        .copyWith(newTitle: title);
    int index = _timedEvents.indexWhere((element) => element.id == t);
    _timedEvents[index] = updatedEvent;
    notifyListeners();
    save();
  }

  void editDesc(String id, String description) {
    String? t = _timedEvents.firstWhere((e) {
      return e.startTime == id;
    }).id;
    print(t);
    FirebaseFirestore.instance
        .collection("timePost")
        .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
        .collection("Time")
        .doc(t)
        .update({'timeDesc': description});

    TimedEvent updatedEvent = _timedEvents
        .firstWhere((element) => element.id == t)
        .copyWith(newTimeDesc: description);
    int index = _timedEvents.indexWhere((element) => element.id == t);
    _timedEvents[index] = updatedEvent;

    notifyListeners();
    save();
  }

  void editFav(String id) {
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
        .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
        .collection("Time")
        .doc(tm)
        .update({'isFavorite': t});
    notifyListeners();
    save();
  }

  void editTime(String id, String time, BuildContext context) {
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
    print(t);
    FirebaseFirestore.instance
        .collection("timePost")
        .doc("1p1TxFvQLoXxlPmIoTj6pVoLDPH2")
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
    _seconds = int.parse(time.substring(0, 2)) * 60 +
        int.parse(time.substring(3, 5)) * 60 +
        int.parse(time.substring(6, 8));

    startTimer();
    save();
  }

  int timeToseconds(String time) {
    return int.parse(time.substring(0, 2)) * 60 +
        int.parse(time.substring(3, 5)) * 60 +
        int.parse(time.substring(6, 8));
  }
}
