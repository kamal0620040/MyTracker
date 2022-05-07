import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../provider/user_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class NutritionStats extends StatefulWidget {
  const NutritionStats({Key? key}) : super(key: key);

  @override
  State<NutritionStats> createState() => _NutritionStatsState();
}

class _NutritionStatsState extends State<NutritionStats> {
  Map<String, dynamic>? data;
  // List<PieChartSectionData> getSections() => PieData.data
  //     .asMap()
  //     .map<int, PieChartSectionData>((index, data) {
  //       final value = PieChartSectionData(
  //           color: data.color, value: data.percent, title: '${data.percent}');
  //       return MapEntry(index, value);
  //     })
  //     .values
  //     .toList();

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );
  Map<String, dynamic>? chartData;
  Map<String, double>? cData = <String, double>{
    "Click on any of the month value.": 0
  };

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Statistic"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Text(
                "Select:",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection("monthly")
              //       .doc(user.uid)
              //       .collection("year")
              //       .doc(DateTime.now().year.toString())
              //       .collection("month")
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const CircularProgressIndicator();
              //     }
              //     var length = snapshot.data?.docs.length;
              //     DocumentSnapshot ds =
              //         snapshot.data?.docs[length - 1];
              //   },
              // ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("monthly")
                    .doc(user.uid)
                    .collection("year")
                    .doc(DateTime.now().year.toString())
                    .collection("month")
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
                  // return InkWell(
                  //   onTap: () => {print("Hello")},
                  //   child: Text('${snapshot.data?.docs}'),
                  // );
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    // itemBuilder: (context, index) => NutritionCard(
                    //   snap: snapshot.data!.docs[index].data(),
                    // ),
                    itemBuilder: (context, index) =>
                        // Text(snapshot.data!.docs[index].data().toString()),
                        // Text(
                        //     snapshot.data!.docs[index].reference.id.toString() +
                        //         " " +
                        //         snapshot.data!.docs[index].data().toString()),
                        Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => {
                          setState(() {
                            chartData = snapshot.data!.docs[index].data();
                            cData = Map.from(chartData!);
                          }),
                          // print('${index}' + chartData.toString())
                        },
                        // child: Text(snapshot.data!.docs[index].id.toString()),
                        child: Center(
                          child: Text(
                            snapshot.data!.docs[index].id.toString(),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Expanded(
              //   child: PieChart(PieChartData(
              //     borderData: FlBorderData(show: false),
              //     sectionsSpace: 0,
              //     sections: getSections(),
              //   )),
              // ),
              // PieChart(dataMap: <String, double>{"kamal": 1.0, "neupane": 2.0}),
              SizedBox(
                height: 10,
              ),
              cData != Null
                  ? PieChart(
                      dataMap: cData!,
                      chartType: ChartType.disc,
                      legendOptions: LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        showLegends: true,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      colorList: [
                        Colors.deepPurpleAccent,
                        Colors.teal,
                        Colors.green,
                        Colors.redAccent,
                      ],
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 2,
                      ),
                    )
                  : Text("No data"),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //         padding: const EdgeInsets.all(16),
              //         child: IndicatorWidget()),
              //   ],
              // ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
            ],
          ),
        ));
  }
}
