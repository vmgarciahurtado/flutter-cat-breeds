import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int value;
  const StarRating({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < value ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
