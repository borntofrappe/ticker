import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    );
  }

  void nextTheme() {
    _index = (_index + 1) % _colors.length;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeDataChangeNotifier(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeDataChangeNotifier>(context).getThemeData(),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.shadow,
          highlightColor: Colors.transparent,
          onTap: () {
            Provider.of<ThemeDataChangeNotifier>(context, listen: false)
                .nextTheme();
          },
          child: Ink(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(
                width: 4,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
