import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytracker/provider/theme_provider.dart';
import 'package:mytracker/screens/login_screen.dart';
import 'package:mytracker/screens/signup_screen.dart';
import 'package:mytracker/utils/colors.dart';

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
    return MaterialApp(
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
      home: const LoginScreen(),
    );
  }
}
