import 'package:flutter/material.dart';
import 'package:ticker/widgets/icon_overlap.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 42.0,
          icon: const IconOverlap(
            size: 42.0,
            backgroundIcon: Icons.square_outlined,
            foregroundIcon: Icons.chevron_left,
            backgroundColor: Colors.black87,
            foregroundColor: Colors.black87,
            foregroundScale: 0.8,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
            title: Text(
              'Ticker',
              style: TextStyle(
                fontSize: 26.0,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
