import 'package:flutter/material.dart';

import 'package:ticker/widgets/custom_button.dart';
import 'package:ticker/widgets/custom_checkbox_list_tile.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
            ListTile(
              title: Text(
                'Preferences'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            ),
            const Expanded(
              child: Preferences(),
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

class Preferences extends StatelessWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CustomCheckboxListTile(
          title: const Text('Forget me not'),
          subtitle: const Text('Save your number for the next time.'),
          onChanged: (bool? value) {
            print(value);
          },
        ),
        CustomCheckboxListTile(
          title: const Text('Zero zero zero'),
          subtitle: const Text('Start fresh from the very beginning.'),
          onChanged: (bool? value) {
            print(value);
          },
        ),
      ],
    );
  }
}
