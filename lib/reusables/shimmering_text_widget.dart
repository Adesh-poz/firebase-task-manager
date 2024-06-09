import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays shimmering text with customizable properties.
class ShimmeringTextWidget extends StatelessWidget {
  /// Constructs a ShimmeringTextWidget with the specified parameters.
  const ShimmeringTextWidget({
    super.key,
    required this.text,
    required this.style,
  });

  /// The text to be displayed.
  final String text;

  /// The style of the text.
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      period: const Duration(seconds: 5),
      gradient: const LinearGradient(
        colors: [
          Colors.blue,
          Colors.indigo,
          Colors.purple,
        ],
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
