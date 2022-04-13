import 'package:flutter/material.dart';
import 'package:ticker/widgets/custom_button.dart';

class CustomRangeListTile extends StatefulWidget {
  final Function onChanged;
  final int min;
  final int max;
  final int value;
  final double buttonSize;
  final double borderWidth;

  const CustomRangeListTile({
    Key? key,
    required this.onChanged,
    this.min = 1,
    this.max = 9,
    this.value = 1,
    this.buttonSize = 24.0,
    this.borderWidth = 1.0,
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

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _value = widget.value;
    });
  }

  void _updateValue() {
    int value = _value >= widget.max ? widget.min : _value + 1;
    setState(() {
      _value = value;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = widget.buttonSize;
    double borderWidth = widget.borderWidth;

    return ListTile(
      onTap: () {
        _updateValue();
      },
      title: Text('Zero' + ' zero' * (_value - 1)),
      subtitle: const Text('Change the columns for your brand new counter.'),
      trailing: CustomButton(
        onPressed: () {
          _updateValue();
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            '$_value',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        size: buttonSize,
        borderWidth: borderWidth,
        showOverlay: false,
      ),
    );
  }
}
