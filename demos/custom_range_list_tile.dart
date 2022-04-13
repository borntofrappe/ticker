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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomRangeListTile(
          onChanged: (int value) {
            print(value);
          },
        ),
      ),
    );
  }
}

class CustomRangeListTile extends StatefulWidget {
  final Function onChanged;
  final int min;
  final int max;
  final int value;
  final double buttonSize;
  final double borderWidth;

  const CustomRangeListTile({
    Key? key,
    required this.onChanged,
    this.min = 1,
    this.max = 5,
    this.value = 1,
    this.buttonSize = 24.0,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  State<CustomRangeListTile> createState() => _CustomRangeListTileState();
}

class _CustomRangeListTileState extends State<CustomRangeListTile> {
  int _value = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _value = widget.value;
    });
  }

  void _updateValue() {
    int value = _value >= widget.max ? widget.min : _value + 1;
    setState(() {
      _value = value;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = widget.buttonSize;
    double borderWidth = widget.borderWidth;

    return ListTile(
      onTap: () {
        _updateValue();
      },
      title: Text('Zero' + ' zero' * (_value - 1)),
      subtitle: const Text('Change the number of columns'),
      trailing: CustomButton(
        onPressed: () {
          _updateValue();
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text('$_value'),
        ),
        size: buttonSize,
        borderWidth: borderWidth,
        showOverlay: false,
      ),
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
