import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytracker/models/users.dart' as model;
import 'package:mytracker/provider/user_provider.dart';
import 'package:provider/provider.dart';

class Nutrition extends StatefulWidget {
  const Nutrition({Key? key}) : super(key: key);

  @override
  State<Nutrition> createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  late PageController pageController;
  int _page = 0;

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        children: [
          Text('Home'),
          Text('Lists'),
          Text('add'),
          Text('bar'),
          Text('Settings'),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0
                  ? Color.fromRGBO(101, 146, 233, 1)
                  : Color.fromRGBO(202, 202, 202, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: _page == 1
                  ? Color.fromRGBO(101, 146, 233, 1)
                  : Color.fromRGBO(202, 202, 202, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2
                  ? Color.fromRGBO(101, 146, 233, 1)
                  : Color.fromRGBO(202, 202, 202, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
              color: _page == 3
                  ? Color.fromRGBO(101, 146, 233, 1)
                  : Color.fromRGBO(202, 202, 202, 1),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: _page == 4
                  ? Color.fromRGBO(101, 146, 233, 1)
                  : Color.fromRGBO(202, 202, 202, 1),
            ),
            label: '',
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
