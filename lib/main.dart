import 'package:flutter/material.dart';
import 'package:test_app_flutter/routing/routings.dart';
import 'package:test_app_flutter/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lightTheme,
      theme: AppTheme.darkTheme,
      restorationScopeId: 'app',// this GlobalKey is help to hot reloading 
      routerConfig: Routings.router,
    );
  }
}
