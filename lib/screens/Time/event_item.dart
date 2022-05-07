import 'package:flutter/material.dart';
import 'timed_event.dart';
import 'timer_service.dart';
import 'package:provider/provider.dart';
import './description_time.dart';

class EventItem extends StatelessWidget {
  final TimedEvent event;

  const EventItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = context.watch<TimerServices>().timerActive;
    TimerServices timerServices = context.watch<TimerServices>();
    TextEditingController _controller = TextEditingController();
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(event.id.toString()),
      // confirmDismiss: (direction) async {
      //   if (event.active) return false;
      //   return true;
      // },
      confirmDismiss: (direction) async {
        if (event.active) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 2),
            content: const Text(
              'Cannot delete ACTIVE timer',
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
          return false;
        }
        return true;
      },
      onDismissed: (direction) {
        context.read<TimerServices>().delete(event.startTime);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onDoubleTap: () {
          if (isActive && event.active) {
            context.read<TimerServices>().stop(event.startTime);
          } else {
            context
                .read<TimerServices>()
                .editTime(event.startTime, event.time, context);
          }
        },
        onTap: () {
          Navigator.pushNamed(context, DescriptionTime.routeName,
              arguments: {'event': event});
        },
        onLongPress: () async {
          _controller.text = event.title;
          var result = await showDialogextract(context, _controller);
          if (result != null) {
            context.read<TimerServices>().edit(event.startTime, result);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      timerServices.editFav(event.startTime);
                    },
                    icon: event.isFavorite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.blue,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.blue,
                          ),
                  ),
                  Text(event.title),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints:
                        const BoxConstraints(maxHeight: 255, maxWidth: 25),
                    onPressed: () async {
                      _controller.text = event.title;
                      var result =
                          await showDialogextract(context, _controller);
                      if (result != null) {
                        context.read<TimerServices>().edit(event.id, result);
                      } else {}
                    },
                    icon: Icon(
                      event.active ? Icons.access_time : Icons.edit,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.active
                        ? context.watch<TimerServices>().currentTime
                        : event.time,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogextract(
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
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _controller,
                  ),
                  Row(
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
                          // if (!_formKey.currentState!.validate()) {
                          //   return;
                          // }
                          if (inputText.isEmpty) return;
                          Navigator.of(context).pop(inputText.trim());
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
