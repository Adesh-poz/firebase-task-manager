import 'package:flutter/material.dart';

/// A button widget for signing in or signing up with customizable properties.
class SignInSignUpButton extends StatefulWidget {
  /// Constructs a SignInSignUpButton with the specified parameters.
  const SignInSignUpButton({
    super.key,
    required this.context,
    required this.isLogin,
    required this.onTap,
  });

  /// The BuildContext of the widget.
  final BuildContext context;

  /// A boolean flag indicating whether the button is for login or signup.
  final bool isLogin;

  /// A callback function called when the button is tapped.
  final Function onTap;

  @override
  State<SignInSignUpButton> createState() => _SignInSignUpButtonState();
}

class _SignInSignUpButtonState extends State<SignInSignUpButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onTap();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          widget.isLogin ? "LOG IN" : "SIGN UP",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
