import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/providers/theme_provider.dart';

class ToggleThemeBtn extends StatelessWidget {
  const ToggleThemeBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => IconButton(
        onPressed: () {
          if (Theme.of(context).brightness == Brightness.dark) {
            themeProvider.toggleTheme(false);
          } else {
            themeProvider.toggleTheme(true);
          }
        },
        icon: Icon(
          Theme.of(context).brightness == Brightness.dark
              ? Icons.light_mode
              : Icons.dark_mode,
        ),
      ),
    );
  }
}
