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
        child: CustomCheckboxListTile(
          onChanged: (bool? value) {
            print(value);
          },
          title: const Text('Forget me not'),
          subtitle: const Text('Save your number for the next time.'),
        ),
      ),
    );
  }
}

class CustomCheckboxListTile extends StatefulWidget {
  final Function onChanged;
  final bool value;
  final Widget title;
  final Widget? subtitle;
  final double checkboxSize;
  final double iconSize;
  final IconData icon;

  const CustomCheckboxListTile({
    Key? key,
    required this.onChanged,
    this.value = false,
    required this.title,
    this.subtitle,
    this.checkboxSize = 24.0,
    this.iconSize = 18.0,
    this.icon = Icons.close,
  }) : super(key: key);

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
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
    Function onChanged = widget.onChanged;
    Widget title = widget.title;
    Widget? subtitle = widget.subtitle;
    double checkboxSize = widget.checkboxSize;
    double iconSize = widget.iconSize;
    IconData icon = widget.icon;

    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize:
              MaterialStateProperty.all(Size(checkboxSize, checkboxSize)),
          maximumSize:
              MaterialStateProperty.all(Size(checkboxSize, checkboxSize)),
          shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
          side: MaterialStateProperty.all(
            BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: _value
            ? Center(
                child: Icon(
                  icon,
                  size: iconSize,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Container(),
        onPressed: () {
          setState(
            () {
              _value = !_value;
              onChanged(_value);
            },
          );
        },
      ),
      onTap: () {
        setState(
          () {
            _value = !_value;
            onChanged(_value);
          },
        );
      },
    );
  }
}
