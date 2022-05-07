import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker/screens/nutrition_screen.dart';
import 'package:provider/provider.dart';

import '../../models/users.dart';
import '../../provider/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';

class EditGoal extends StatefulWidget {
  double proteinValue;
  double fatsValue;
  double carbsValue;
  double energyValue;
  EditGoal(
      {Key? key,
      required this.proteinValue,
      required this.fatsValue,
      required this.carbsValue,
      required this.energyValue})
      : super(key: key);

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  TextEditingController _proteinController = TextEditingController();
  TextEditingController _fatsController = TextEditingController();
  TextEditingController _carbsController = TextEditingController();
  TextEditingController _energyController = TextEditingController();

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
        widget.proteinValue = double.parse(_proteinController.text);
        widget.carbsValue = double.parse(_carbsController.text);
        widget.fatsValue = double.parse(_fatsController.text);
        widget.energyValue = double.parse(_energyController.text);
      });
      showSnackBar("Goal Posted Successfully.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _proteinController.text = widget.proteinValue.toString();
      _carbsController.text = widget.carbsValue.toString();
      _fatsController.text = widget.fatsValue.toString();
      _energyController.text = widget.energyValue.toString();
    });
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Nutrition(),
                ),
              );
            },
          ),
          title: Text("Edit Goal:")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
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
                    "Update Goals",
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
            ]),
          )
        ]),
      ),
    );
  }
}
