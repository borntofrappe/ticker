import 'package:flutter/material.dart';
import 'package:ticker/widgets/icon_overlap.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            iconSize: 42.0,
            icon: const IconOverlap(
              size: 42.0,
              backgroundIcon: Icons.square_outlined,
              foregroundIcon: Icons.chevron_right,
              backgroundColor: Colors.black87,
              foregroundColor: Colors.black87,
              foregroundScale: 0.8,
            ),
          )
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
    );
  }
}
