import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_task_manager/reusables/reusable_logo_widget.dart';
import 'package:firebase_task_manager/reusables/color_gradiant_bg.dart';
import 'package:firebase_task_manager/reusables/reusable_textfield.dart';
import 'package:firebase_task_manager/reusables/signin_signup_button.dart';
import 'package:firebase_task_manager/screens/home_screen.dart';
import 'package:firebase_task_manager/constants.dart';

/// This class contains the code for the UI and Logic for the Sign-Up Screen.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  /// Firebase Sign-Up Authentication method.
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((onValue) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // icon: const Icon(Icons.error_outline),
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
                error.toString(),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            fontWeight: FontWeight.w900,
            fontSize: 30.0,
          ),
        ),
      ),
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
                children: [
                  // Logo widget
                  const LogoWidget(
                      imageName: "assets/images/task_manager_logo.png"),

                  const SizedBox(height: 30.0),

                  // Username text field
                  ReusableTextField(
                    text: "Enter Username",
                    icon: Icons.person_outline_rounded,
                    isPasswordType: false,
                    controller: _usernameTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Email text field
                  ReusableTextField(
                    text: "Enter E-mail ID",
                    icon: Icons.email_outlined,
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
                      } else if (value.length < 6) {
                        return 'Password should be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Loading indicator or Sign Up button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SignInSignUpButton(
                          context: context,
                          isLogin: false,
                          onTap: _signUp,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
