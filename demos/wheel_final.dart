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

  static BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(20.0),
  );

  static Color background = Colors.grey[100]!;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: background,
              borderRadius: borderRadius,
            ),
            width: itemExtent,
            height: itemExtent,
          ),
          ListWheelScrollView(
            overAndUnderCenterOpacity: 0,
            itemExtent: itemExtent,
            children: List<Widget>.generate(
              10,
              (index) => Item(
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: borderWidth,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: borderRadius,
            ),
            width: itemExtent,
            height: itemExtent,
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final Widget child;

  const Item({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: child,
      ),
    );
  }
}
