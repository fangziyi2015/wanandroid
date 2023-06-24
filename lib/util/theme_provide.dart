import 'package:flutter/material.dart';

class ThemeProvide extends ChangeNotifier {
  int _themeIndex;

  int get value => _themeIndex;

  ThemeProvide(this._themeIndex);

  void setTheme(int index) {
    _themeIndex = index;
    notifyListeners();
  }
}
