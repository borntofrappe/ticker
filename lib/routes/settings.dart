import 'package:flutter/material.dart';
import 'package:ticker/widgets/squared_outlined_button.dart';
import 'package:ticker/widgets/toggle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

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

  void _updateSharedPreferences(bool isToggleTrue) async {
    final instance = await SharedPreferences.getInstance();

    setState(() {
      _hasSharedPreferences = isToggleTrue;
      instance.setBool('shared-preferences', _hasSharedPreferences);
    });

    if (!_hasSharedPreferences && instance.get('value') != null) {
      instance.remove('value');
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
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: SquaredOutlinedButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pop(context);
                },
                size: 32.0,
                child: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).primaryColor,
                  size: 32.0,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Ticker',
                style: TextStyle(
                  fontSize: 26.0,
                  fontFamily: 'Inter',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Preferences'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Inter',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Toggle(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Forget me not',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              subtitle: Text(
                'Save your number for the next time.',
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Inter',
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onChanged: (bool value) {
                _updateSharedPreferences(value);
              },
              value: _hasSharedPreferences,
            ),
          ],
        ),
      ),
    );
  }
}
