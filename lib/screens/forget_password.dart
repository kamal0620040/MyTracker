import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker/resources/auth_methods.dart';
import 'package:mytracker/screens/login_screen.dart';
import 'package:mytracker/utils/utils.dart';

import '../widgets/text_field_input.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _isLoading = false;
  void sendResetRequest(String email) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await AuthMethods().resetPassword(email);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
      }
      showSnackBar("Email sent to mail.", context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      _isLoading = false;
      showSnackBar(e.toString(), context);
    }
  }

  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Receive an email to reset your password.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Enter your email:",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Write Here",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () => sendResetRequest(_emailController.text),
                  child: Container(
                    child: _isLoading
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
                            "Reset Password",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
