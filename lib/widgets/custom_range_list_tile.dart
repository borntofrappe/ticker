import 'package:flutter/material.dart';
import 'package:ticker/widgets/custom_button.dart';

class CustomRangeListTile extends StatelessWidget {
  final Function onChanged;
  final int min;
  final int max;
  final int value;
  final Widget title;
  final Widget? subtitle;
  final double buttonSize;
  final double borderWidth;

  const CustomRangeListTile({
    Key? key,
    required this.onChanged,
    this.min = 1,
    this.max = 9,
    this.value = 1,
    required this.title,
    this.subtitle,
    this.buttonSize = 24.0,
    this.borderWidth = 1.0,
  }) : super(key: key);

  void _updateValue() {
    onChanged(value >= max ? min : value + 1);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _updateValue();
      },
      title: title,
      subtitle: subtitle,
      trailing: CustomButton(
        onPressed: () {
          _updateValue();
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            '$value',
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
