import 'package:flutter/material.dart';

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
    'primary': Color(0xFFFF7088),
    'secondary': Color(0xFF181515),
    'tertiary': Color(0xFF2C2325),
    'background': Color(0xFFFFE0E4),
    'shadow': Color(0xFFFFACAC),
    'scaffoldBackgroundColor': Color(0xFFFFF7F8),
  },
  {
    'primary': Color(0xFFF6F352),
    'secondary': Color(0xDD252323),
    'tertiary': Color(0x87222220),
    'background': Color(0xFFFFFEEC),
    'shadow': Color(0xFFFFF891),
    'scaffoldBackgroundColor': Color(0xFFFFFFEA),
  },
  {
    'primary': Color(0xFF39bEFF),
    'secondary': Color(0xFF212425),
    'tertiary': Color(0xFF353E42),
    'background': Color(0xFFE7F7FF),
    'shadow': Color(0xFFB5E6FF),
    'scaffoldBackgroundColor': Color(0xFFF3FBFF),
  },
  {
    'primary': Color(0xFFFFA1DD),
    'secondary': Color(0xFF30222B),
    'tertiary': Color(0xFF493542),
    'background': Color.fromARGB(255, 255, 224, 243),
    'shadow': Color(0xFFFFDFF3),
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
    notifyListeners();
  }
}
