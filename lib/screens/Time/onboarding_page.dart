import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mytracker/screens/login_screen.dart';
import 'timer_app.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: IntroductionScreen(
          isProgress: true,
          pages: [
            PageViewModel(
              title: 'Money Matters',
              body:
                  'Lorem Ipsum is a great way to generate random text field y to generate random tex',
              image: buildImage('assets/money.svg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'No Nasty Nutrients',
              body: 'Lorem Ipsum is a great way to generate random text field',
              image: buildImage('assets/food.svg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Time is Trailing',
              body: 'Lorem Ipsum is a great way to generate random text field',
              image: buildImage('assets/time.svg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'You are ready! ',
              body: 'Lorem Ipsum is a great way to generate random text field ',
              image: buildImage1('assets/done.png'),
              footer: ButtonTheme(
                height: 50.0,
                minWidth: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(TimerApp.routeName);
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              decoration: getPageDecoration(),
            )
          ],
          done: const Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onDone: () {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const LoginScreen(),
              ),
            );
          },
          dotsDecorator: getDotDecoration(),
          showNextButton: true,
          next: const Icon(Icons.arrow_forward),
          showSkipButton: true,
          skip: const Text('Skip'),
          animationDuration: 500,
        ),
      ),
    );
  }
}

DotsDecorator getDotDecoration() => DotsDecorator(
      color: Colors.purple,
      activeColor: Colors.purple,
      activeSize: Size(18, 20),
    );
Widget buildImage(String path) {
  return Center(
    child: SvgPicture.asset(
      path,
      fit: BoxFit.fitHeight,
    ),
  );
}

Widget buildImage1(String path) {
  return Center(
    child: Image.asset(
      path,
      width: 250,
    ),
  );
}

PageDecoration getPageDecoration() {
  return PageDecoration(
    titleTextStyle: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    bodyTextStyle: const TextStyle(
      fontSize: 22,
    ),
    bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
    // pageColor: Colors.white70,
  );
}
