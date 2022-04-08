import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class HomeNutrition extends StatefulWidget {
  const HomeNutrition({Key? key}) : super(key: key);

  @override
  State<HomeNutrition> createState() => _HomeNutritionState();
}

class _HomeNutritionState extends State<HomeNutrition> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "Hello, Manee!",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle: Text(
                  "Subtitle is her",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                leading: ClipOval(
                  child: Image.network(
                      "https://cdn.ku.edu.np/xh1551345964.cat/2/100/100"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  _RadialProgress(
                    width: width * 0.4,
                    height: width * 0.4,
                    progress: 0.65,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _IngredientProgress(
                        ingredient: "Protein",
                        progress: 0.3,
                        progressColor: Colors.redAccent,
                        leftAmount: 72,
                        width: width * 0.28,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _IngredientProgress(
                        ingredient: "Carbs",
                        progress: 0.2,
                        progressColor: Colors.deepPurpleAccent,
                        leftAmount: 252,
                        width: width * 0.28,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _IngredientProgress(
                        ingredient: "Fats",
                        progress: 0.1,
                        progressColor: Colors.teal,
                        leftAmount: 261,
                        width: width * 0.28,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {
  final String? ingredient;
  final int? leftAmount;
  final double? progress, width;
  final Color? progressColor;

  const _IngredientProgress({
    Key? key,
    this.ingredient,
    this.leftAmount,
    this.progress,
    this.width,
    this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingredient!.toUpperCase(),
          style: GoogleFonts.poppins(
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 10,
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(87, 87, 87, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    // color: Color.fromRGBO(225, 225, 225, 1),
                  ),
                ),
                Container(
                  height: 10,
                  width: width! * progress!,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: progressColor),
                ),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Text('${leftAmount}g left')
          ],
        )
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final width;
  final height;
  final progress;
  const _RadialProgress({Key? key, this.width, this.height, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(progress: progress),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "1731",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "kcal left",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double? progress;

  _RadialPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress!;
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90), math.radians(-relativeProgress), false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegates) {
    return true;
  }
}
