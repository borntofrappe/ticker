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
        highlightColor: Colors.black12,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static List<Widget> numbers = List<Widget>.generate(
    10,
    (index) => Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text('$index'),
    ),
  );

  static List<Color> materialPalette = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  static List<Widget> colors = materialPalette
      .map(
        (color) => Container(
          // any positive width&height forces the container to expand
          width: 1,
          height: 1,
          color: color,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomRangeList(
              onChanged: (int index) {
                print(index);
              },
              children: numbers,
            ),
            const SizedBox(height: 16.0),
            CustomRangeList(
              onChanged: (int index) {
                print(materialPalette[index]);
              },
              children: colors,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRangeList extends StatefulWidget {
  final Function onChanged;
  final List<Widget> children;
  final int index;
  final double buttonSize;
  final double borderWidth;

  const CustomRangeList({
    Key? key,
    required this.onChanged,
    required this.children,
    this.index = 0,
    this.buttonSize = 24.0,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  State<CustomRangeList> createState() => _CustomRangeListState();
}

class _CustomRangeListState extends State<CustomRangeList> {
  int _index = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _index = widget.index;
    });
  }

  void _updateValue() {
    setState(() {
      _index = (_index + 1) % widget.children.length;
    });
    widget.onChanged(_index);
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = widget.buttonSize;
    double borderWidth = widget.borderWidth;
    List<Widget> children = widget.children;

    return CustomButton(
      onPressed: () {
        _updateValue();
      },
      child: children[_index],
      size: buttonSize,
      borderWidth: borderWidth,
      showOverlay: false,
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size;
  final double borderWidth;
  final bool showOverlay;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.size,
    required this.borderWidth,
    this.showOverlay = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        onPressed: onPressed,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: FittedBox(
            child: child,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
          side: MaterialStateProperty.all(
            BorderSide(
              color: Theme.of(context).primaryColor,
              width: borderWidth,
            ),
          ),
          overlayColor: showOverlay
              ? MaterialStateProperty.resolveWith(
                  (states) {
                    return states.contains(MaterialState.pressed)
                        ? Theme.of(context).highlightColor
                        : null;
                  },
                )
              : MaterialStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }
}
