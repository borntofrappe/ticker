import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black87,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Wheel(),
      ),
    );
  }
}

class Wheel extends StatelessWidget {
  const Wheel({Key? key}) : super(key: key);

  static double borderWidth = 8.0;
  static double itemExtent = 200;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ListWheelScrollView(
            itemExtent: itemExtent,
            children: const <Widget>[
              Item(
                borderWidth: 8.0,
              ),
            ],
          ),
          ListWheelScrollView(
            overAndUnderCenterOpacity: 0,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              10,
              (index) => Item(
                digit: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final int? digit;
  final double? borderWidth;
  const Item({
    Key? key,
    this.digit,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: borderWidth != null
            ? BoxDecoration(
                border: Border.all(
                  width: borderWidth ?? 0,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
        child: FittedBox(
          child: digit != null ? Text('$digit') : null,
        ),
      ),
    );
  }
}
