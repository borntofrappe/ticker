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
    'primary': Color(0xFFFF7088),
    'secondary': Color(0xFF181515),
    'tertiary': Color(0xFF2C2325),
    'background': Color(0xFFFDDADF),
    'shadow': Color(0xFFFFACAC),
    'scaffoldBackgroundColor': Color(0xFFFFF3F5),
  },
  {
    'primary': Color(0xFFF6F352),
    'secondary': Color(0xDD252323),
    'tertiary': Color(0x87222220),
    'background': Color(0xFFFFFEBB),
    'shadow': Color(0xFFFFF891),
    'scaffoldBackgroundColor': Color(0xFFFFFECF),
  },
  {
    'primary': Color(0xFF39bEFF),
    'secondary': Color(0xFF212425),
    'tertiary': Color(0xFF353E42),
    'background': Color(0xFFDEF4FF),
    'shadow': Color(0xFFB5E6FF),
    'scaffoldBackgroundColor': Color(0xFFF3FBFF),
  },
  {
    'primary': Color(0xFFFFA1DD),
    'secondary': Color(0xFF30222B),
    'tertiary': Color(0xFF493542),
    'background': Color(0xFFFFC0E8),
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
