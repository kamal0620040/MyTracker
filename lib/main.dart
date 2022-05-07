import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytracker/provider/theme_provider.dart';
import 'package:mytracker/provider/user_provider.dart';
import 'package:mytracker/screens/Time/description_time.dart';
import 'package:mytracker/screens/Time/event_list.dart';
import 'package:mytracker/screens/Time/onboarding_page.dart';
import 'package:mytracker/screens/Time/timer_app.dart';
import 'package:mytracker/screens/Time/timer_service.dart';
import 'package:mytracker/screens/home_screen.dart';
import 'package:mytracker/screens/login_screen.dart';
import 'package:mytracker/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // will display the status bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: mobileBackgroundColorDark),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TimerServices()),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyTracker',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        // home: const SafeArea(
        //   child: Scaffold(
        //     // appBar: AppBar(
        //     //   title: const Text("Temporary"),
        //     //   backgroundColor: Colors.green,
        //     // ),
        //     body: Center(
        //       child: Text("Here, we go..."),
        //     ),
        //   ),
        // ),
        // home: const LoginScreen(),
        // home: const TimerApp(),

        routes: {
          TimerApp.routeName: (ctx) => const TimerApp(),
          EventList.routeName: (ctx) => const EventList(),
          DescriptionTime.routeName: (ctx) => const DescriptionTime(),
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const HomeScreen();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                );
              }
              return const OnBoardingPage();
            }),
      ),
    );
  }
}
