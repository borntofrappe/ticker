import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black87,
      ),
      home: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Preferences'.toUpperCase(),
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
            Toggle(
              title: const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Forget me not',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              subtitle: const Text(
                'Save your number for the next time.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
              onChanged: (value) {
                // here you'd implement the logic connected to the changing value
                print(value);
              },
            )
          ],
        ),
      ),
    );
  }
}

class Toggle extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final bool value;
  final Function onChanged;

  const Toggle({
    Key? key,
    required this.title,
    this.subtitle,
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
    Widget? subtitle = widget.subtitle;
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
              activeColor: Theme.of(context).primaryColor,
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
            activeColor: Theme.of(context).primaryColor,
          );
  }
}
