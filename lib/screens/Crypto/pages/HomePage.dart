import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Favorites.dart';
import 'Markets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController viewController;

  @override
  void initState() {
    super.initState();
    viewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TRACKER",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Crypto Today",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //   },
                  //   padding: EdgeInsets.all(0),
                  //   icon: (themeProvider.themeMode == ThemeMode.light)
                  //       ? Icon(Icons.dark_mode)
                  //       : Icon(Icons.light_mode),
                  // ),
                ],
              ),
              TabBar(
                controller: viewController,
                tabs: [
                  Tab(
                    child: Text(
                      "Markets",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Favorites",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: viewController,
                  children: [
                    Markets(),
                    Favorites(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
