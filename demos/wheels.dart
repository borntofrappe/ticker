import 'package:flutter/material.dart';
import 'dart:math';

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
        child: Wheels(),
      ),
    );
  }
}

class Wheels extends StatelessWidget {
  const Wheels({Key? key}) : super(key: key);

  static int wheels = 4;
  static double margin = 4.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemExtent = min(200.0, (width - 2 * margin * wheels) / wheels);

    return Row(
      children: List<Widget>.generate(
        wheels,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: margin),
            child: Wheel(itemExtent: itemExtent),
          ),
        ),
      ),
    );
  }
}

class Wheel extends StatelessWidget {
  final double itemExtent;

  const Wheel({Key? key, required this.itemExtent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListWheelScrollView(
        itemExtent: itemExtent,
        children: List<Widget>.generate(
          10,
          (index) => Item(
            digit: index,
            borderWidth: itemExtent * 0.04,
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final int digit;
  final double borderWidth;
  const Item({
    required this.digit,
    required this.borderWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: borderWidth,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: FittedBox(
          child: Text('$digit'),
        ),
      ),
    );
  }
}
