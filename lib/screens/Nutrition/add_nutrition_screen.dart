import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mytracker/utils/utils.dart';
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
  DateTime date = DateTime.now();
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
        _proteinController.text = jsondata["parsed"][0]["food"]["nutrients"]
                ["PROCNT"]
            .toStringAsFixed(2);
        _energyController.text = jsondata["parsed"][0]["food"]["nutrients"]
                ["ENERC_KCAL"]
            .toStringAsFixed(2);
        _fatsController.text = jsondata["parsed"][0]["food"]["nutrients"]["FAT"]
            .toStringAsFixed(2);
        _carbController.text = jsondata["parsed"][0]["food"]["nutrients"]
                ["CHOCDF"]
            .toStringAsFixed(2);
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

  @override
  void dispose() {
    _nameController.dispose();
    _carbController.dispose();
    _proteinController.dispose();
    _fatsController.dispose();
    _energyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What did you eat?",
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            const SizedBox(
              height: 10,
            ),
            // TextFieldInput(
            //   textEditingController: _nameController,
            //   hintText: "Write Here",
            //   textInputType: TextInputType.text,
            // ),
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
          ],
        ),
      ),
    );
  }
}
