import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {

  static final Box<bool> _box = Hive.box<bool>('theme');


  // get theme
  bool isDarkMode = _box.get('isDarkMode') ?? false;
  
  // Toggle Theme
  Future<void> toggleTheme(bool model) async {
    final data = model;
    await _box.put('isDarkMode', data);
    isDarkMode = data;

    notifyListeners();
  }
}
