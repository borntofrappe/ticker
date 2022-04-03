import 'package:flutter/material.dart';
import 'package:ticker/widgets/squared_outlined_button.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListTile(
          trailing: SquaredOutlinedButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            size: 32.0,
            child: Icon(
              Icons.chevron_right,
              color: Theme.of(context).primaryColor,
              size: 32.0,
            ),
          ),
        ),
      ),
    );
  }
}
