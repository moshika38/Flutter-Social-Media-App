import 'package:flutter/material.dart';
import 'package:test_app_flutter/routing/routings.dart';
import 'package:test_app_flutter/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // theme: AppTheme.darkTheme,
      restorationScopeId: 'app', // this GlobalKey is help to hot reloading
      routerConfig: Routings.router,
    );
  }
}
