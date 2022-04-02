import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Wheel(),
        ),
      ),
    );
  }
}

class Wheel extends StatelessWidget {
  const Wheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListWheelScrollView(
        itemExtent: 200,
        children: List<Widget>.generate(10, (index) => Item(digit: index)),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final int digit;
  const Item({required this.digit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 8.0,
            color: Colors.black87,
          ),
          color: Colors.black12,
        ),
        child: FittedBox(
          child: Text('$digit'),
        ),
      ),
    );
  }
}
