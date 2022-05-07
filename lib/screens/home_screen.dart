import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker/models/users.dart';
import 'package:mytracker/provider/user_provider.dart';
import 'package:mytracker/resources/auth_methods.dart';
import 'package:mytracker/screens/login_screen.dart';
import 'package:mytracker/screens/Time/onboarding_page.dart';
import 'package:mytracker/screens/Time/timer_app.dart';
import 'package:mytracker/screens/nutrition_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  void navigateToNutrition() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Nutrition(),
      ),
    );
  }

  void navigateToTime() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimerApp(),
      ),
    );
  }
  // void navigateToTime() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const OnBoardingPage(),
  //     ),
  //   );
  // }

  void navigateToExpense() {}

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 55,
            ),
            ListTile(
              title: Text(
                "Hello, ${user.name}!",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Text(
                "Subtitle is here",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              leading: CircleAvatar(
                radius: 25,
                child: ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Select:",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: navigateToTime,
              child: Container(
                child: Text(
                  "Time",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: Color.fromRGBO(101, 146, 233, 1),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: navigateToExpense,
              child: Container(
                child: Text(
                  "Expense",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: Color.fromRGBO(101, 146, 233, 1),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: navigateToNutrition,
              child: Container(
                child: Text(
                  "Nutrition",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: Color.fromRGBO(101, 146, 233, 1),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            InkWell(
              onTap: () async {
                AuthMethods().signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Container(
                child: Text(
                  "Sign Out",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                width: 100,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: Color.fromRGBO(101, 146, 233, 1),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
