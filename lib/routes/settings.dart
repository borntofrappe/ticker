import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticker/widgets/custom_button.dart';
import 'package:ticker/widgets/custom_checkbox_list_tile.dart';

class Settings extends StatelessWidget {
  final int scrollValue;

  const Settings({
    Key? key,
    this.scrollValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Navigation(),
            const ListTile(
              title: Text(
                'Ticker',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Preferences(
                scrollValue: scrollValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.chevron_left,
          size: 32.0,
          color: Colors.black87,
        ),
        size: 32.0,
        color: Colors.black87,
        overlayColor: Colors.black12,
        borderWidth: 1.0,
      ),
    );
  }
}

class Preferences extends StatefulWidget {
  final int scrollValue;

  const Preferences({
    Key? key,
    required this.scrollValue,
  }) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  bool _shortOnTime = false;
  bool _forgetMeNot = false;

  @override
  void initState() {
    super.initState();

    getBoolPreferences();
  }

  void getBoolPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _shortOnTime = preferences.getBool('short-on-time') ?? false;
        _forgetMeNot = preferences.getBool('forget-me-not') ?? false;
      },
    );
  }

  void setBoolPreference(String key, bool? value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value ?? false);
  }

  void setIntPreference(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  void removePreference(String key) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(key)) {
      preferences.remove(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            'Preferences'.toUpperCase(),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ),
        CustomCheckboxListTile(
          title: const Text('Forget me not'),
          subtitle: const Text('Save your number for the next time.'),
          onChanged: (bool? value) {
            setBoolPreference('forget-me-not', value);
            if (value ?? false) {
              setIntPreference('scroll-value', widget.scrollValue);
            } else {
              removePreference('scroll-value');
            }
          },
          value: _forgetMeNot,
        ),
        CustomCheckboxListTile(
          title: const Text('Short on time'),
          subtitle: const Text('Drastically reduce the initial animation.'),
          onChanged: (bool? value) {
            setBoolPreference('short-on-time', value);
          },
          value: _shortOnTime,
        ),
      ],
    );
  }
}
