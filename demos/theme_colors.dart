import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xff171719),
    secondary: const Color(0xfffefefe),
    background: const Color(0xffffffff),
    shadow: const Color(0x55a3a3a3),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xff9c9c9c),
    secondary: const Color(0xff1b1a1f),
    background: const Color(0xff161618),
    shadow: const Color(0xaa4b4a52),
  ),
);

class ThemeChangeNotifier extends ChangeNotifier {
  bool _isDark = false;

  void setDarkTheme(isDark) {
    _isDark = isDark;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeChangeNotifier(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeChangeNotifier>(context)._isDark
          ? darkTheme
          : lightTheme,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Theme.of(context).colorScheme.background,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Theme.of(context).colorScheme.primary,
              displayColor: Theme.of(context).colorScheme.primary,
            ),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 64.0,
                height: 64.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                      width: 4.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: const FittedBox(
                    child: Text(
                      '0',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 4.0,
                    ),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return states.contains(MaterialState.pressed)
                          ? Theme.of(context).colorScheme.shadow
                          : null;
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.add,
                    size: 32.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              const Toggle(),
            ],
          ),
        ),
      ),
    );
  }
}

class Toggle extends StatefulWidget {
  const Toggle({Key? key}) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (bool? value) {
        if (value != null) {
          setState(
            () {
              _value = value;
            },
          );
          Provider.of<ThemeChangeNotifier>(context, listen: false)
              .setDarkTheme(_value);
        }
      },
    );
  }
}
