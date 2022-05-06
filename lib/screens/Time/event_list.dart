import 'package:flutter/material.dart';

import 'timed_event.dart';
import 'event_item.dart';
import 'timer_service.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../models/users.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);
  static const String routeName = '/eventlist';

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool fav = false;

  void _toggleFav() {
    setState(() {
      fav = !fav;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final catId = routeArgs['catId'];
    final title = routeArgs['title'];
    TimerServices timerServices = context.watch<TimerServices>();
    List<TimedEvent> timedEvents = timerServices.timedEvents;
    List<TimedEvent> timedEventsFav = timerServices.timedEventsFav;

    return ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(title!),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            // color: Colors.white,
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          timerServices.addNew(catId!, context, user.uid);
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 35,
                          color: context.watch<TimerServices>().timerActive
                              ? Colors.grey[400]
                              : Colors.blue[800],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            _toggleFav();
                          },
                          icon: fav
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.blue,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(
                            height: 1,
                          ),
                      itemCount:
                          fav ? timedEventsFav.length : timedEvents.length,
                      itemBuilder: (context, index) {
                        return fav
                            ? EventItem(event: timedEventsFav[index])
                            : EventItem(event: timedEvents[index]);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
