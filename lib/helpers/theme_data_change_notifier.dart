import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Map<String, Color>> _colors = [
  {
    'primary': Colors.black87,
    'secondary': Colors.black87,
    'tertiary': Colors.black54,
    'background': Colors.white,
    'shadow': Colors.black12,
    'scaffoldBackgroundColor': Colors.white,
  },
  {
    'primary': Color(0xFFF84E6A),
    'secondary': Color(0xFF443434),
    'tertiary': Color(0xFF382126),
    'background': Color(0xFFFFE6E9),
    'shadow': Color(0xFFFFBCBC),
    'scaffoldBackgroundColor': Color(0xFFFFECEF),
  },
  {
    'primary': Color(0xFFECE251),
    'secondary': Color(0xDD3A3131),
    'tertiary': Color(0x8533332D),
    'background': Color(0xFFFFFEE8),
    'shadow': Color(0xFFFFFBC5),
    'scaffoldBackgroundColor': Color(0xFFFFFFF0),
  },
  {
    'primary': Color(0xFF36BBFD),
    'secondary': Color(0xFF262D30),
    'tertiary': Color(0xFF273F49),
    'background': Color(0xFFE7F7FF),
    'shadow': Color(0xFFCCEDFD),
    'scaffoldBackgroundColor': Color(0xFFE7F7FF),
  },
  {
    'primary': Color(0xFFFA94D4),
    'secondary': Color(0xFF573E4E),
    'tertiary': Color(0xFF502A43),
    'background': Color(0xFFFFE5F5),
    'shadow': Color(0xFFFFCEEE),
    'scaffoldBackgroundColor': Color(0xFFFFF0F9),
  },
];

class ThemeDataChangeNotifier extends ChangeNotifier {
  int _index = 0;

  ThemeData getThemeData() {
    Map colors = _colors[_index];

    return ThemeData(
      scaffoldBackgroundColor: colors['scaffoldBackgroundColor'],
      colorScheme: const ColorScheme.light().copyWith(
        primary: colors['primary'],
        secondary: colors['secondary'],
        tertiary: colors['tertiary'],
        background: colors['background'],
        shadow: colors['shadow'],
      ),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 24.0, color: colors['secondary']),
        headline2: TextStyle(fontSize: 14.0, color: colors['tertiary']),
        headline3: TextStyle(
          fontSize: 14.0,
          color: colors['secondary'],
          fontWeight: FontWeight.w700,
        ),
        headline4: TextStyle(fontSize: 14.0, color: colors['tertiary']),
      ),
      fontFamily: 'Inter',
    );
  }

  void nextTheme() {
    _index = (_index + 1) % _colors.length;
    _saveIndexTheme();
    notifyListeners();
  }

  Future<void> retrieveIndexTheme() async {
    final preferences = await SharedPreferences.getInstance();
    _index = preferences.getInt('index-theme') ?? 0;
    notifyListeners();
  }

  void _saveIndexTheme() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt('index-theme', _index);
  }
}
