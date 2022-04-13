import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticker/widgets/custom_button.dart';
import 'package:ticker/widgets/custom_checkbox_list_tile.dart';

import 'package:ticker/helpers/screen_arguments.dart';

class Settings extends StatelessWidget {
  final int scrollValue;

  const Settings({
    Key? key,
    this.scrollValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          final preferences = await SharedPreferences.getInstance();
          bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;

          Navigator.pop(context, forgetMeNot);
          return false;
        },
        child: SafeArea(
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
        onPressed: () async {
          final preferences = await SharedPreferences.getInstance();
          bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;

          Navigator.pop(context, forgetMeNot);
        },
        child: Icon(
          Icons.chevron_left,
          color: Theme.of(context).primaryColor,
        ),
        size: 32.0,
        borderWidth: 1.0,
      ),
      trailing: CustomButton(
        onPressed: () async {
          final preferences = await SharedPreferences.getInstance();

          bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;

          if (forgetMeNot) {
            preferences.setInt('scroll-value', 0);
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
            arguments: ScreenArguments(
              scrollValue: 0,
            ),
          );
        },
        child: Icon(
          Icons.chevron_right,
          color: Theme.of(context).primaryColor,
        ),
        size: 32.0,
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
          onChanged: (bool? value) {
            setBoolPreference('forget-me-not', value);
            if (value ?? false) {
              setIntPreference('scroll-value', widget.scrollValue);
            } else {
              removePreference('scroll-value');
            }
          },
          value: _forgetMeNot,
          title: const Text('Forget me not'),
          subtitle: const Text('Save your number for the next time.'),
        ),
        CustomCheckboxListTile(
          onChanged: (bool? value) {
            setBoolPreference('short-on-time', value);
          },
          value: _shortOnTime,
          title: const Text('Short on time'),
          subtitle: const Text('Drastically reduce the initial animation.'),
        ),
      ],
    );
  }
}
