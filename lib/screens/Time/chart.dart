import 'package:flutter/material.dart';
import '../../models/users.dart';
import '../../provider/user_provider.dart';
import 'timed_event.dart';
import 'package:provider/provider.dart';
import 'timer_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pie_chart_sections.dart';
import 'indicators_widget.dart';

class PieChartTime extends StatefulWidget {
  const PieChartTime({Key? key}) : super(key: key);

  @override
  State<PieChartTime> createState() => _PieChartTimeState();
}

class _PieChartTimeState extends State<PieChartTime> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    TimerServices timerServices = context.watch<TimerServices>();
    List<TimedEvent> timedEvents = timerServices.timedEventsAll;
    timerServices.load('c1', user.uid);

    List<Map<String, dynamic>> pieSectionList = [];
    for (var element in timedEvents) {
      pieSectionList.add({
        'category': ' ${element.categoryTime}',
        'time': timerServices.timeToseconds(element.time)
      });
    }
    Map<String, int> pieSection = {};

    if (pieSectionList.isNotEmpty) {
      for (var e in pieSectionList) {
        if (pieSection.containsKey(e['category'])) {
          pieSection.update(e['category'], (value) => value + e['time'] as int);
        } else {
          pieSection.addEntries([MapEntry(e['category'], e['time'])]);
        }
      }
    }
    return pieSectionList.isEmpty
        ? Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'No Stats at the moment!',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  height: 30,
                ),
                Icon(
                  Icons.auto_graph_outlined,
                  size: 80,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Try adding some Timer!!',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          )
        : SingleChildScrollView(
            child: Card(
              // color: Colors.white,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          enabled: true,
                          touchCallback: (FlTouchEvent fltouchevent,
                              PieTouchResponse? pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse!.touchedSection
                                      is FlLongPressEnd ||
                                  pieTouchResponse.touchedSection
                                      is FlPanEndEvent) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              }
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: getSections(touchedIndex, pieSection),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.315,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: IndicatorsWidget(pieSection),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
