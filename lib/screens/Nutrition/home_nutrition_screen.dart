import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import '../../models/users.dart';
import '../../provider/user_provider.dart';
import '../../widgets/nutrition_card.dart';

class HomeNutrition extends StatefulWidget {
  final String uid;
  const HomeNutrition({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomeNutrition> createState() => _HomeNutritionState();
}

class _HomeNutritionState extends State<HomeNutrition> {
  bool _isLoading = false;
  List<String> datelist = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  DateTime now = DateTime.now();

  int? fat = 0;
  int? carbs = 0;
  int? protein = 0;
  int? energy = 0;

  void initial(String uid) async {
    FirebaseFirestore.instance
        .collection('monthly')
        .doc(uid)
        .collection("year")
        .doc(now.year.toString())
        .collection('month')
        .doc(datelist[now.month - 1])
        .snapshots()
        .listen((DocumentSnapshot value) async {
      fat = value['fats'].ceil();
      protein = value['protein'].ceil();
      energy = value['energy'].ceil();
      carbs = value['carbs'].ceil();
    });
    // FirebaseFirestore.instance
    //   .collection('monthly')
    //   .doc(uid)
    //   .collection("year")
    //   .doc(now.year.toString())
    //   .collection('month')
    //   .doc(datelist[now.month - 1])
    //   .snapshots()
    //   .listen((DocumentSnapshot value) {
    // setState(() {
    //   fat = value['fats'].ceil();
    //   protein = value['protein'].ceil();
    //   energy = value['energy'].ceil();
    //   carbs = value['carbs'].ceil();
    //   print(fat);
    // });
    // });
    // DocumentSnapshot value = await docRef.get();
    // if (value.exists) {
    //   fat = value['fats'].ceil();
    //   protein = value['protein'].ceil();
    //   energy = value['energy'].ceil();
    //   carbs = value['carbs'].ceil();
    // }
  }

  @override
  void initState() {
    super.initState();
    // _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    initial(user.uid);
    DateTime startOfTheDay = new DateTime(now.year, now.month, now.day);

    //and this gives you the first millisecond of the next day
    var endOfTheDay = startOfTheDay.add(Duration(days: 1));

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(children: [
                    Row(
                      children: [
                        _RadialProgress(
                          width: width * 0.4,
                          height: width * 0.4,
                          energyValue: energy,
                          progress:
                              (energy as num) / 1000, // 1000 is target value
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
                              progress: (protein as int) /
                                  300, // 300 is protein target value
                              progressColor: Colors.redAccent,
                              leftAmount: 300 - (protein as int),
                              width: width * 0.28,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _IngredientProgress(
                              ingredient: "Carbs",
                              progress: (carbs as num) / 200,
                              progressColor: Colors.deepPurpleAccent,
                              leftAmount: 200 - (carbs as int),
                              width: width * 0.28,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _IngredientProgress(
                              ingredient: "Fats",
                              progress: (fat as num) / 200,
                              progressColor: Colors.teal,
                              leftAmount: 100 - (fat as int),
                              width: width * 0.28,
                            ),
                          ],
                        )
                      ],
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Today:",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.breakfast_dining),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Breakfast:",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("nutritionPost")
                      .orderBy("date")
                      .where('date', isGreaterThanOrEqualTo: startOfTheDay)
                      .where('date', isLessThan: endOfTheDay)
                      .where('meal', isEqualTo: 'Breakfast')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // print(snapshot.data!.docs.length);
                    if (snapshot.data!.docs.length == 0) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                "Nothing to show.",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => NutritionCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.lunch_dining),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Lunch:",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("nutritionPost")
                      .orderBy("date")
                      .where('date', isGreaterThanOrEqualTo: startOfTheDay)
                      .where('date', isLessThan: endOfTheDay)
                      .where('meal', isEqualTo: 'Lunch')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // print(snapshot.data!.docs.length);
                    if (snapshot.data!.docs.length == 0) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                "Nothing to show.",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => NutritionCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.dinner_dining),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Dinner:",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("nutritionPost")
                      .orderBy("date")
                      .where('date', isGreaterThanOrEqualTo: startOfTheDay)
                      .where('date', isLessThan: endOfTheDay)
                      .where('meal', isEqualTo: 'Dinner')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                "Nothing to show.",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => NutritionCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
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
  final energyValue;
  final progress;
  const _RadialProgress(
      {Key? key, this.width, this.height, this.energyValue, this.progress})
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
                  text: (1000 - energyValue).toString(),
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
