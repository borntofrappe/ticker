import 'package:flutter/material.dart';
import 'package:ticker/widgets/squared_outlined_button.dart';
import 'package:ticker/widgets/toggle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final int count;
  final int value;
  const Settings({
    Key? key,
    required this.count,
    required this.value,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _hasSharedPreferences = false;

  void _getSharedPreferences() async {
    final instance = await SharedPreferences.getInstance();

    setState(() {
      _hasSharedPreferences = instance.getBool('shared-preferences') ?? false;
    });
  }

  void _updateSharedPreferences(bool isToggleTrue, BuildContext context) async {
    final instance = await SharedPreferences.getInstance();

    setState(() {
      _hasSharedPreferences = isToggleTrue;
    });

    instance.setBool('shared-preferences', _hasSharedPreferences);

    if (_hasSharedPreferences) {
      final bool success = await instance.setInt('value', widget.value);
      if (success) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gotcha, your number is safe and sound.'),
          duration: Duration(seconds: 3),
        ));
      }
    } else if (instance.containsKey('value')) {
      final bool success = await instance.remove('value');
      if (success) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Understood, next time we start from ${' zero' * widget.count}.'),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: SquaredOutlinedButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pop(context);
                },
                size: Theme.of(context).iconTheme.size ?? 32.0,
                child: const Icon(
                  Icons.chevron_left,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Ticker',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    title: Text(
                      'Preferences'.toUpperCase(),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  Toggle(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        'Forget me not',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    subtitle: Text(
                      'Save your number for the next time.',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    onChanged: (bool value) {
                      _updateSharedPreferences(value, context);
                    },
                    value: _hasSharedPreferences,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
