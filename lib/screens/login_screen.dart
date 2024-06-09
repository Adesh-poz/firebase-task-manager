import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_task_manager/constants.dart';
import 'package:firebase_task_manager/screens/home_screen.dart';
import 'package:firebase_task_manager/screens/registration_screen.dart';
import 'package:firebase_task_manager/reusables/reusable_logo_widget.dart';
import 'package:firebase_task_manager/reusables/reusable_textfield.dart';
import 'package:firebase_task_manager/reusables/shimmering_text_widget.dart';
import 'package:firebase_task_manager/reusables/signin_signup_button.dart';
import 'package:firebase_task_manager/reusables/color_gradiant_bg.dart';

/// This class contains the code for the UI and Logic for the Login Screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  /// Firebase Sign-In Validation method.
  void _signIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((onValue) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Error dialog box when login fails
            return AlertDialog(
              title: const Text(
                'Error!',
                textAlign: TextAlign.center,
              ),
              titleTextStyle: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.w900,
                fontSize: 30.0,
                color: Colors.black,
              ),
              content: Text(
                'Please enter a valid Email ID and Password!',
                style: TextStyle(
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  // fontWeight: FontWeight.w900,
                  fontSize: 18.0,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBGColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: gradientBGDecoration(primaryBGColor, secondaryBGColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                  Center(
                    child: ShimmeringTextWidget(
                      text: 'Task Manager',
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.ubuntu(fontWeight: FontWeight.bold)
                                .fontFamily,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Logo widget
                  const Center(
                    child: LogoWidget(
                        imageName: "assets/images/task_manager_logo.png"),
                  ),

                  const SizedBox(height: 30),

                  // Email text field
                  ReusableTextField(
                    text: "Enter Username",
                    icon: Icons.person_outline_rounded,
                    isPasswordType: false,
                    controller: _emailTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password text field
                  ReusableTextField(
                    text: "Enter Password",
                    icon: Icons.lock_outline,
                    isPasswordType: true,
                    controller: _passwordTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Loading indicator or Sign In button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SignInSignUpButton(
                          context: context,
                          isLogin: true,
                          onTap: _signIn,
                        ),

                  // Sign Up option
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Method to build the Sign Up option row
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
