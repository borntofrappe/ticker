import 'package:flutter/material.dart';
import 'package:ticker/widgets/squared_outlined_button.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
          ],
        ),
      ),
    );
  }
}
