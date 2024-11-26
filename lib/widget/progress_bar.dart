import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
        strokeWidth: 5,
      ),
    );
  }
}
