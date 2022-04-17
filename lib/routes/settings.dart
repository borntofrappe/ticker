import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticker/widgets/custom_button.dart';
import 'package:ticker/widgets/custom_checkbox_list_tile.dart';
import 'package:ticker/widgets/custom_range_list_tile.dart';

import 'package:ticker/helpers/screen_arguments.dart';

import 'package:ticker/helpers/theme_data_change_notifier.dart';

class SettingsChangeNotifier extends ChangeNotifier {
  int? _count;

  void setCount(int count) {
    _count = count;
  }

  int? getCount() {
    return _count;
  }
}

class Settings extends StatelessWidget {
  final int count;
  final int scrollValue;

  const Settings({
    Key? key,
    this.count = 3,
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
          child: ChangeNotifierProvider(
            create: (_) => SettingsChangeNotifier(),
            child: Column(
              children: <Widget>[
                Navigation(
                  previousCount: count,
                ),
                ListTile(
                  title: Text(
                    'Ticker',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  subtitle: Text(
                    'A trivial counter app.',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Expanded(
                  child: Preferences(
                    count: count,
                    scrollValue: scrollValue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  final int previousCount;

  const Navigation({
    Key? key,
    this.previousCount = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 42.0;

    return ListTile(
      leading: CustomButton(
        onPressed: () async {
          final preferences = await SharedPreferences.getInstance();
          bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;

          Navigator.pop(context, forgetMeNot);
        },
        child: Icon(
          Icons.chevron_left_rounded,
          color: Theme.of(context).colorScheme.primary,
          semanticLabel: 'Go to previous counter',
        ),
        size: size,
      ),
      trailing: CustomButton(
        onPressed: () async {
          final preferences = await SharedPreferences.getInstance();

          bool forgetMeNot = preferences.getBool('forget-me-not') ?? false;

          if (forgetMeNot) {
            preferences.setInt('scroll-value', 0);
          }

          int? count =
              Provider.of<SettingsChangeNotifier>(context, listen: false)
                  .getCount();

          if (count != null) {
            preferences.setInt('count', count);
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
            arguments: ScreenArguments(
              scrollValue: 0,
              count: count ?? previousCount,
            ),
          );
        },
        child: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.primary,
          semanticLabel: 'Go to new counter',
        ),
        size: size,
      ),
    );
  }
}

class Preferences extends StatefulWidget {
  final int scrollValue;
  final int count;

  const Preferences({
    Key? key,
    required this.scrollValue,
    required this.count,
  }) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  bool _shortOnTime = false;
  bool _forgetMeNot = false;
  int _count = 1;

  @override
  void initState() {
    super.initState();

    getBoolPreferences();
    _count = widget.count;
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
    double widgetSize = 28.0;
    double iconSize = 20.0;

    return ListView(
      children: <Widget>[
        ListTile(
          dense: true,
          title: Text(
            'App Preferences'.toUpperCase(),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        CustomCheckboxListTile(
          onChanged: (bool value) {
            setState(() {
              _forgetMeNot = value;
            });

            setBoolPreference('forget-me-not', _forgetMeNot);
            if (_forgetMeNot) {
              setIntPreference('scroll-value', widget.scrollValue);
            } else {
              removePreference('scroll-value');
            }
          },
          value: _forgetMeNot,
          title: Text(
            'Forget me not',
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: Text(
            'Some numbers are worth remembering.',
            style: Theme.of(context).textTheme.headline4,
          ),
          checkboxSize: widgetSize,
          iconSize: iconSize,
        ),
        CustomCheckboxListTile(
          onChanged: (bool value) {
            setState(() {
              _shortOnTime = value;
            });
            setBoolPreference('short-on-time', _shortOnTime);
          },
          value: _shortOnTime,
          title: Text(
            'Short on time',
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: Text(
            'Even few seconds deserve saving.',
            style: Theme.of(context).textTheme.headline4,
          ),
          checkboxSize: widgetSize,
          iconSize: iconSize,
        ),
        ListTile(
          onTap: () {
            Provider.of<ThemeDataChangeNotifier>(context, listen: false)
                .nextTheme();
          },
          title: Text(
            'Color splash',
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: Text(
            'A bit of flair to brighten up the day.',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: CustomButton(
            onPressed: () {
              Provider.of<ThemeDataChangeNotifier>(context, listen: false)
                  .nextTheme();
            },
            child: Padding(
              padding: EdgeInsets.all(widgetSize / 1.5),
              child: Container(
                width: widgetSize,
                height: widgetSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            size: widgetSize,
            showOverlay: false,
          ),
        ),
        const SizedBox(height: 16.0),
        ListTile(
          dense: true,
          title: Text(
            'Counter Preferences'.toUpperCase(),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        CustomRangeListTile(
          onChanged: (int value) {
            setState(() {
              _count = value;
            });

            Provider.of<SettingsChangeNotifier>(context, listen: false)
                .setCount(_count);
          },
          min: 1,
          max: 5,
          value: _count,
          title: Text(
            'Fresh start',
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: Text(
            'Count from zero' + ' zero' * (_count - 1) + '.',
            style: Theme.of(context).textTheme.headline4,
          ),
          buttonSize: widgetSize,
        ),
      ],
    );
  }
}
