import 'timer_service.dart';
import 'package:flutter/material.dart';
import 'event_list.dart';
import 'package:provider/provider.dart';

final dummyCategories = [
  const CategoryTime(
    catId: 'c1',
    title: 'Productivity',
    color: Colors.purple,
  ),
  const CategoryTime(
    catId: 'c2',
    title: 'Entertainment',
    color: Colors.red,
  ),
  const CategoryTime(
    catId: 'c3',
    title: 'Leisure',
    color: Colors.orange,
  ),
  const CategoryTime(
    catId: 'c4',
    title: 'Relaxation',
    color: Colors.amber,
  ),
  const CategoryTime(
    catId: 'c5',
    title: 'Guilty Pleasure',
    color: Colors.blue,
  ),
  const CategoryTime(
    catId: 'c6',
    title: 'Sports',
    color: Colors.green,
  ),
  const CategoryTime(
    catId: 'c7',
    title: 'Work Out',
    color: Colors.lightBlue,
  ),
  const CategoryTime(
    catId: 'c8',
    title: 'Others',
    color: Colors.teal,
  ),
];

class Category {
  final String catId;
  final String title;
  final Color color;
  int see = 1;
  Category({required this.catId, required this.title, required this.color});

  String catidToTitle(String catid) {
    return (dummyCategories
        .firstWhere((element) => ' ${element.catId}' == catid)
        .title);
  }

  Color catidToColor(String catid) {
    return (dummyCategories
        .firstWhere((element) => ' ${element.catId}' == catid)
        .color);
  }
}

class CategoryTime extends StatelessWidget {
  static const routeNAme = '/categorytime';
  final String catId;
  final String title;
  final Color color;
  const CategoryTime(
      {Key? key, required this.catId, required this.title, required this.color})
      : super(key: key);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(EventList.routeName, arguments: {
      'id': catId,
      'title': title,
    });
  }

  @override
  Widget build(BuildContext context) {
    TimerServices timerServices = context.watch<TimerServices>();
    return InkWell(
      onTap: () {
        TimerServices();
        timerServices.load(catId);
        Navigator.of(context).pushNamed(EventList.routeName,
            arguments: {'catId': catId, 'title': title});
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
