import 'package:flutter/material.dart';

/// A widget to display a logo image.
///
/// This widget takes the [imageName] as a parameter, which is the path to the image asset.
/// It renders the image with the specified [imageName] and applies BoxFit.fitWidth to ensure
/// the image fits its width within the available space.
class LogoWidget extends StatelessWidget {
  /// Constructs a LogoWidget with the given [imageName].
  const LogoWidget({super.key, required this.imageName});

  /// The path to the image asset.
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 240,
      height: 240,
    );
  }
}
