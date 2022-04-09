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
    return Scaffold(
      body: Center(
        child: CustomCheckbox(
          value: true,
          onChanged: (bool? value) {
            print(value);
          },
          child: const Center(
            child: Icon(
              Icons.close,
              size: 28.0,
              color: Colors.black87,
            ),
          ),
          size: 32.0,
          color: Colors.black87,
          borderWidth: 1.0,
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final Function onChanged;
  final Widget child;
  final double size;
  final Color color;
  final double borderWidth;

  const CustomCheckbox({
    Key? key,
    this.value = false,
    required this.onChanged,
    required this.child,
    required this.size,
    required this.color,
    required this.borderWidth,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _value = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;

    return OutlinedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size(size, size)),
        maximumSize: MaterialStateProperty.all(Size(size, size)),
        shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
        side: MaterialStateProperty.all(
          BorderSide(
            color: widget.color,
            width: widget.borderWidth,
          ),
        ),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: _value ? widget.child : Container(),
      onPressed: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
    );
  }
}
