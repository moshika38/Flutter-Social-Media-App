import 'package:flutter/material.dart';

class ToggleThemeBtn extends StatelessWidget {
  const ToggleThemeBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return  
        IconButton(
          onPressed: () {},
          icon: Icon(Theme.of(context).brightness == Brightness.dark 
              ? Icons.light_mode 
              : Icons.dark_mode),
        
    );
  }
}
