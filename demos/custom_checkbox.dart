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
        child: CustomCheckbox(
          onChanged: (bool value) {
            print(value);
          },
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final Function onChanged;
  final bool value;
  final double checkboxSize;
  final double iconSize;
  final double borderWidth;
  final IconData icon;

  const CustomCheckbox({
    Key? key,
    required this.onChanged,
    this.value = false,
    this.checkboxSize = 24.0,
    this.iconSize = 18.0,
    this.borderWidth = 1.0,
    this.icon = Icons.close,
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

  void _updateValue() {
    setState(
      () {
        _value = !_value;
      },
    );
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    double checkboxSize = widget.checkboxSize;
    double iconSize = widget.iconSize;
    double borderWidth = widget.borderWidth;
    IconData icon = widget.icon;

    return CustomButton(
      onPressed: () {
        _updateValue();
      },
      child: _value
          ? Padding(
              padding: EdgeInsets.all((checkboxSize - iconSize) / 2),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            )
          : Container(),
      size: checkboxSize,
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
