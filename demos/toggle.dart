import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// https://codepen.io/borntofrappe/pen/LYeOEJw
void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Reminders'.toUpperCase(),
                  style: const TextStyle(fontSize: 12.0),
                ),
              ),
              Toggle(
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    'High-priority reminders',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                subtitle: const Text(
                  'Play sound even when Silent mode is on.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
                onChanged: (value) {
                  // here you'd implement the logic connected to the changing vaòue
                  print(value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Toggle extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final bool value;
  final Function onChanged;

  const Toggle({
    Key? key,
    required this.title,
    required this.subtitle,
    this.value = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
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
    Widget title = widget.title;
    Widget subtitle = widget.subtitle;
    Function onChanged = widget.onChanged;

    return Theme.of(context).platform == TargetPlatform.iOS
        ? ListTile(
            title: title,
            subtitle: subtitle,
            trailing: CupertinoSwitch(
              value: _value,
              onChanged: (bool value) {
                setState(() => _value = value);
                onChanged(_value);
              },
            ),
            onTap: () {
              setState(() => _value = !_value);
              onChanged(_value);
            },
          )
        : SwitchListTile(
            title: title,
            subtitle: subtitle,
            value: _value,
            onChanged: (bool value) {
              setState(() => _value = value);
              onChanged(value);
            },
          );
  }
}
