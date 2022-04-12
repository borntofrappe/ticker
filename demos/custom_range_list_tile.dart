import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black87,
      ),
      home: const Scaffold(
        body: Center(
          child: CustomRangeListTile(
            value: 3,
          ),
        ),
      ),
    );
  }
}

class CustomRangeListTile extends StatefulWidget {
  final int min;
  final int max;
  final int value;

  const CustomRangeListTile({
    Key? key,
    this.min = 1,
    this.max = 5,
    this.value = 1,
  }) : super(key: key);

  @override
  State<CustomRangeListTile> createState() => _CustomRangeListTileState();
}

class _CustomRangeListTileState extends State<CustomRangeListTile> {
  int _value = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _value = widget.value;
    });
  }

  void _updateValue() {
    int value = _value >= widget.max ? widget.min : _value + 1;
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _updateValue();
      },
      title: Text('Zero' + ' zero' * (_value - 1)),
      subtitle: const Text('Change the number of columns'),
      trailing: SizedBox(
        width: 32.0,
        height: 32.0,
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
            side: MaterialStateProperty.all(
              BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.0,
              ),
            ),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: FittedBox(
            child: Text(
              '$_value',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 24.0,
              ),
            ),
          ),
          onPressed: () {
            _updateValue();
          },
        ),
      ),
    );
  }
}
