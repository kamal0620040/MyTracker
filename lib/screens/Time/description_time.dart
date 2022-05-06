import 'package:flutter/material.dart';
import 'timed_event.dart';
import 'package:provider/provider.dart';
import 'timer_service.dart';
import 'category.dart';

class DescriptionTime extends StatelessWidget {
  static const routeName = '/descriptionTime';
  static String b = '';
  const DescriptionTime({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cat = Category(catId: 'c1', title: 'title', color: Colors.red);
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, TimedEvent>;
    final event = routeArgs['event'];
    TimerServices timerServices = context.watch<TimerServices>();

    List<TimedEvent> timedEvents = timerServices.timedEventsAll;

    String a = '';

    a = timedEvents.firstWhere((element) {
      return element.id == event!.id;
    }).timeDesc;
    b = a;
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event!.title,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                _controller.text = event.timeDesc;
                _controller.text = b;

                var result = await showDialogextract1(context, _controller);
                if (result != null) {
                  context
                      .read<TimerServices>()
                      .editDesc(event.startTime, result);
                }
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Start Date/Time',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Category',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Favorite',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.startTime.substring(0, 10) +
                        '    ' +
                        event.startTime.substring(11, 19),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    event.active ? 'Active' : 'Inactive',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    cat.catidToTitle(
                      ' ${event.categoryTime}',
                    ),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(event.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        a,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogextract1(
      BuildContext context, TextEditingController _controller) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              width: MediaQuery.of(context).size.width * 1,
              // height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      autofocus: true,
                      showCursor: true,
                      controller: _controller,
                      expands: true,
                      maxLines: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String inputText = _controller.text;

                            if (inputText.isEmpty) return;
                            Navigator.of(context).pop(inputText.trim());
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
