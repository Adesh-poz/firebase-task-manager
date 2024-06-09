import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable text field widget with customizable properties.
class ReusableTextField extends StatefulWidget {
  /// Constructs a ReusableTextField with the specified parameters.
  const ReusableTextField({
    super.key,
    required this.text,
    required this.icon,
    required this.isPasswordType,
    required this.controller,
    this.validator,
  });

  /// The label text displayed above the text field.
  final String text;

  /// The icon displayed as a prefix to the text field.
  final IconData icon;

  /// A flag indicating whether the text field should be obscured (e.g., for password input).
  final bool isPasswordType;

  /// The controller for the text field.
  final TextEditingController controller;

  /// An optional validator function for input validation.
  final String? Function(String?)? validator;

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPasswordType;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordType ? _isObscured : false,
      enableSuggestions: !widget.isPasswordType,
      autocorrect: !widget.isPasswordType,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        suffixIcon: widget.isPasswordType
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: _toggleVisibility,
              )
            : null,
        labelText: widget.text,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.openSans().fontFamily,
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: widget.isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}
