import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytracker/resources/auth_methods.dart';
import 'package:mytracker/screens/login_screen.dart';
import 'package:mytracker/widgets/text_field_input.dart';
import '../utils/utils.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
    // print(res);
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.only(all: 20.0),
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
                        //Text field input for email
                        Flexible(
                          child: Container(),
                          flex: 1,
                        ),
                        Text(
                          "Create an account",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Sign up to continue",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(202, 202, 202, 1),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // circular widget to accept and show our selected file
                        Stack(
                          children: [
                            Center(
                              child: _image != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : const CircleAvatar(
                                      radius: 64,
                                      backgroundImage: NetworkImage(
                                          "https://freepikpsd.com/file/2019/10/default-profile-picture-png-1-Transparent-Images.png"),
                                    ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 175,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Name",
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
                          hintText: "Enter your name",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Email",
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
                          hintText: "Enter your email",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Text field input for password
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldInput(
                          textEditingController: _passwordController,
                          hintText: "Enter your password",
                          textInputType: TextInputType.text,
                          isPass: true,
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        //button signup
                        InkWell(
                          onTap: signUpUser,
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
                                    "Create account",
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
                        const SizedBox(
                          height: 24,
                        ),
                        //transition for signin
                        Flexible(
                          child: Container(),
                          flex: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Already have an account?",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(202, 202, 202, 1),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            GestureDetector(
                              onTap: navigateToLogin,
                              child: Container(
                                child: Text(
                                  " Sign In",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(101, 146, 233, 1),
                                    ),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ],
                        )
                        // Text("Already have an account? Sign In",style: ,),
                      ]),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
