import 'package:flutter/material.dart';

/// Creates a BoxDecoration with a gradient background.
///
/// The gradient background starts with the [primaryColor] at the top-left corner
/// and ends with the [secondaryColor] at the bottom-right corner.
BoxDecoration gradientBGDecoration(Color primaryColor, Color secondaryColor) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        primaryColor,
        secondaryColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
