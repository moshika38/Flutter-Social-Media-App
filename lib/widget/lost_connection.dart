import 'package:flutter/material.dart';

class LostConnection extends StatelessWidget {
  const LostConnection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Lost Connection ! Try again later',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
