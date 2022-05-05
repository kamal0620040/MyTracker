import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mytracker/models/monthly.dart';
import 'package:mytracker/resources/firestore_methods.dart';
import 'package:mytracker/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../models/users.dart';
import '../../provider/user_provider.dart';
import '../../widgets/text_field_input.dart';

class AddNutrition extends StatefulWidget {
  const AddNutrition({Key? key}) : super(key: key);

  @override
  State<AddNutrition> createState() => _AddNutritionState();
}

class _AddNutritionState extends State<AddNutrition> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _energyController = TextEditingController();
  TextEditingController _proteinController = TextEditingController();
  TextEditingController _fatsController = TextEditingController();
  TextEditingController _carbController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _servingController = TextEditingController();
  DateTime date = DateTime.now();
  bool _isLoading = false;
  bool _isLoadingForPost = false;
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
  final items = ['Breakfast', 'Lunch', 'Dinner'];
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );
  String? meal;

  void doSomething() async {
    setState(() {
      _isLoading = true;
    });
    final url =
        'https://api.edamam.com/api/food-database/parser?nutrition-type=logging&app_id=07d50733&app_key=80fcb49b500737827a9a23f7049653b9&ingr=' +
            '${_nameController.text}';
    var response = await http.get(
      Uri.parse(url),
    );
    print(response.statusCode);
    var jsondata = jsonDecode(response.body);
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200 && jsondata["parsed"].length > 0) {
      // print(jsondata["parsed"][0]["food"]["nutrients"]);
      setState(() {
        // _nameController.text = "test";
        if (_quantityController.text.isEmpty) {
          _proteinController.text = jsondata["parsed"][0]["food"]["nutrients"]
                  ["PROCNT"]
              .toStringAsFixed(2);
          _energyController.text = jsondata["parsed"][0]["food"]["nutrients"]
                  ["ENERC_KCAL"]
              .toStringAsFixed(2);
          _fatsController.text = jsondata["parsed"][0]["food"]["nutrients"]
                  ["FAT"]
              .toStringAsFixed(2);
          _carbController.text = jsondata["parsed"][0]["food"]["nutrients"]
                  ["CHOCDF"]
              .toStringAsFixed(2);
          _quantityController.text =
              jsondata["parsed"][0]["quantity"].toStringAsFixed(2);
          _servingController.text =
              jsondata["parsed"][0]["measure"]["label"].toString();
        } else {
          _proteinController.text = (jsondata["parsed"][0]["food"]["nutrients"]
                      ["PROCNT"] *
                  double.parse(_quantityController.text))
              .toStringAsFixed(2);
          _energyController.text = (jsondata["parsed"][0]["food"]["nutrients"]
                      ["ENERC_KCAL"] *
                  double.parse(_quantityController.text))
              .toStringAsFixed(2);
          _fatsController.text = (jsondata["parsed"][0]["food"]["nutrients"]
                      ["FAT"] *
                  double.parse(_quantityController.text))
              .toStringAsFixed(2);
          _carbController.text = (jsondata["parsed"][0]["food"]["nutrients"]
                      ["CHOCDF"] *
                  double.parse(_quantityController.text))
              .toStringAsFixed(2);
          _servingController.text =
              jsondata["parsed"][0]["measure"]["label"].toString();
        }
      });
    } else if (response.statusCode == 400) {
      if (_nameController.text.isEmpty) {
        showSnackBar("What do you eat field is empty.", context);
      }
    } else if (jsondata["parsed"].length == 0) {
      showSnackBar("Cannot find the data for entered field.", context);
    } else {
      showSnackBar(
          "Something went wrong. Please, enter data manually.", context);
    }
  }

  void clear() {
    _nameController.clear();
    _quantityController.clear();
    _servingController.clear();
    _energyController.clear();
    _proteinController.clear();
    _fatsController.clear();
    _carbController.clear();
    setState(() {
      meal = null;
    });
  }

  void post(
    String uid,
  ) async {
    try {
      setState(() {
        _isLoadingForPost = true;
      });

      // Getting the courrent month data
      final docRef = FirebaseFirestore.instance
          .collection('monthly')
          .doc(uid)
          .collection('month')
          .doc(datelist[date.month - 1]);

      DocumentSnapshot value = await docRef.get();
      // print(value.data());
      // print(double.parse(value['carbs'].toString()));
      if (value.exists) {
        String ares = await FireStoreMethods().uploadMonth(
          uid,
          date.year.toString(),
          datelist[date.month - 1],
          double.parse(_proteinController.text) +
              double.parse(value['protein'].toString()),
          double.parse(_energyController.text) +
              double.parse(value['energy'].toString()),
          double.parse(_fatsController.text) +
              double.parse(value['fats'].toString()),
          double.parse(_carbController.text) +
              double.parse(value['carbs'].toString()),
        );
      } else {
        String ares = await FireStoreMethods().uploadMonth(
          uid,
          date.year.toString(),
          datelist[date.month - 1],
          double.parse(_proteinController.text),
          double.parse(_energyController.text),
          double.parse(_fatsController.text),
          double.parse(_carbController.text),
        );
      }
      String res = await FireStoreMethods().uploadNutrition(
        _nameController.text,
        uid,
        date,
        meal!,
        double.parse(_quantityController.text),
        _servingController.text,
        double.parse(_energyController.text),
        double.parse(_proteinController.text),
        double.parse(_fatsController.text),
        double.parse(_carbController.text),
      );
      setState(() {
        _isLoadingForPost = false;
      });
      if (res == "success") {
        showSnackBar('Posted', context);
        clear();
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _carbController.dispose();
    _proteinController.dispose();
    _fatsController.dispose();
    _energyController.dispose();
    _quantityController.dispose();
    _servingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            clear();
          },
        ),
        title: Text("Add something"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    Text(
                      "What did you eat?",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      textEditingController: _nameController,
                      hintText: "Write Here",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(2005),
                                  lastDate: DateTime(2030),
                                );

                                // if 'CANCEL' => null
                                if (newDate == null) return;

                                // if 'OK' => Datetime
                                setState(() {
                                  date = newDate;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${datelist[date.month - 1]} ${date.day}, ${date.year}',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meal:",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            DropdownButton(
                              value: meal,
                              items: items.map(buildMenuItem).toList(),
                              onChanged: (value) => setState(
                                () {
                                  meal = value.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quantity:"),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldInput(
                                textEditingController: _quantityController,
                                hintText: "Write Here",
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Unit:"),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldInput(
                                textEditingController: _servingController,
                                hintText: "Write Here",
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nutrient:"),
                        GestureDetector(
                          onTap: doSomething,
                          child: Container(
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      height: 21,
                                      width: 21,
                                    ),
                                  )
                                : Text(
                                    "Autofill",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(101, 146, 233, 1),
                                      ),
                                    ),
                                  ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Energy (g):"),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldInput(
                                textEditingController: _energyController,
                                hintText: "Write Here",
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Protien (kcal):"),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldInput(
                                textEditingController: _proteinController,
                                hintText: "Write Here",
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Fats (g):"),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldInput(
                                textEditingController: _fatsController,
                                hintText: "Write Here",
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Carb (g):"),
                              SizedBox(
                                height: 10,
                              ),
                              TextFieldInput(
                                textEditingController: _carbController,
                                hintText: "Write Here",
                                textInputType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        post(user.uid);
                      },
                      child: Container(
                        child: _isLoadingForPost
                            ? const Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  height: 20,
                                  width: 20,
                                ),
                              )
                            : Text(
                                "Add Food",
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
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
