import 'package:flutter/material.dart';
import 'category_home.dart';
import 'chart.dart';

class TimerApp extends StatefulWidget {
  static const routeName = '/timerapp';

  const TimerApp({Key? key}) : super(key: key);

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  int currentIndex = 0;
  final screens = [
    const CategoryHome(),
    const PieChartTime(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('   TimerApp'),
        ),
        // backgroundColor: Colors.grey[200],
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          type: BottomNavigationBarType.shifting,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.lock_clock,
              ),
              backgroundColor: Colors.blue[800],
              label: 'Clock',
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.bar_chart,
              ),
              backgroundColor: Colors.blue[800],
              label: 'Stats',
            ),
          ],
        ),
      ),
    );
  }
}
