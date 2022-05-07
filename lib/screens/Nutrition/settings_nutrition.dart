import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker/provider/user_provider.dart';
import 'package:mytracker/resources/firestore_methods.dart';
import 'package:mytracker/screens/Nutrition/edit_goal.dart';
import 'package:mytracker/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../widgets/text_field_input.dart';

class NutritionSetting extends StatefulWidget {
  const NutritionSetting({Key? key}) : super(key: key);

  @override
  State<NutritionSetting> createState() => _NutritionSettingState();
}

class _NutritionSettingState extends State<NutritionSetting> {
  bool _showForm = true;
  Map<String, dynamic>? goalData;
  TextEditingController _proteinController = TextEditingController();
  TextEditingController _fatsController = TextEditingController();
  TextEditingController _carbsController = TextEditingController();
  TextEditingController _energyController = TextEditingController();
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef =
          FirebaseFirestore.instance.collection('nutritionGoal');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  getData(String docId) async {
    var collectionRef = FirebaseFirestore.instance.collection('nutritionGoal');

    var doc = await collectionRef.doc(docId).get();
    goalData = Map.from(doc.data()!);
    // print(doc.data());
    return doc.data();
  }

  void postGoal(String uid) async {
    String res = await FireStoreMethods().uploadGoal(
      uid,
      double.parse(_proteinController.text.toString()),
      double.parse(_energyController.text.toString()),
      double.parse(_fatsController.text.toString()),
      double.parse(_carbsController.text.toString()),
    );
    if (res == "success") {
      setState(() {
        _showForm = false;
      });
      showSnackBar("Goal Posted Successfully.", context);
    }
  }

  @override
  void dispose() {
    _carbsController.dispose();
    _proteinController.dispose();
    _energyController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    // checker() async {
    //   return await checkIfDocExists(user.uid);
    // }

    // checker();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: checkIfDocExists(user.uid),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // return Text(snapshot.data.toString());
                      if (snapshot.data == false) {
                        return Container(
                          child: Column(children: [
                            Text(
                              "Protein:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _proteinController,
                              hintText: "Write Here",
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Energy:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _energyController,
                              hintText: "Write Here",
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Carbs:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _carbsController,
                              hintText: "Write Here",
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Fats:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _fatsController,
                              hintText: "Write Here",
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                postGoal(user.uid);
                              },
                              child: Container(
                                child:
                                    //  _isLoadingForPost ?
                                    //  const Center(
                                    //     child: SizedBox(
                                    //       child: CircularProgressIndicator(
                                    //         color: Color.fromRGBO(255, 255, 255, 1),
                                    //       ),
                                    //       height: 20,
                                    //       width: 20,
                                    //     ),
                                    //   )
                                    // :
                                    Text(
                                  "Upload Goals",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                          ]),
                        );
                      } else {
                        return FutureBuilder(
                          future: getData(user.uid),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Your Goals:",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) => EditGoal(
                                                  proteinValue:
                                                      goalData!["protein"],
                                                  fatsValue: goalData!["fats"],
                                                  carbsValue:
                                                      goalData!["carbs"],
                                                  energyValue:
                                                      goalData!["energy"],
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      // margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color.fromRGBO(87, 87, 87, 1),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Following are you montly nutrient goals :\n",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              // margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color.fromRGBO(
                                                      87, 87, 87, 1),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              child: Column(children: [
                                                Text(
                                                  "Protein",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(goalData!["protein"]
                                                        .toString() +
                                                    ' g'),
                                              ])),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              // margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color.fromRGBO(
                                                      87, 87, 87, 1),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              child: Column(children: [
                                                Text(
                                                  "Energy",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(goalData!["energy"]
                                                        .toString() +
                                                    ' kcal'),
                                              ])),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              // margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color.fromRGBO(
                                                      87, 87, 87, 1),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              child: Column(children: [
                                                Text(
                                                  "Fats",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(goalData!["fats"]
                                                        .toString() +
                                                    ' g'),
                                              ])),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              // margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color.fromRGBO(
                                                      87, 87, 87, 1),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              child: Column(children: [
                                                Text(
                                                  "Carbohydrates",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(goalData!["carbs"]
                                                        .toString() +
                                                    ' g'),
                                              ])),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            );
                          }),
                        );
                      }
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
