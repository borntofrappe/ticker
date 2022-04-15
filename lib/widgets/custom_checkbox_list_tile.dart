import 'package:flutter/material.dart';
import 'package:ticker/widgets/custom_button.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final Function onChanged;
  final bool value;
  final Widget title;
  final Widget? subtitle;
  final double checkboxSize;
  final IconData icon;
  final double iconSize;

  const CustomCheckboxListTile({
    Key? key,
    required this.onChanged,
    this.value = false,
    required this.title,
    this.subtitle,
    this.checkboxSize = 28.0,
    this.icon = Icons.close_rounded,
    this.iconSize = 20.0,
  }) : super(key: key);

  void _updateValue() {
    onChanged(!value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      onTap: () {
        _updateValue();
      },
      trailing: CustomButton(
        onPressed: () {
          _updateValue();
        },
        child: value
            ? Padding(
                padding: EdgeInsets.all((checkboxSize - iconSize) / 2),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Container(),
        size: checkboxSize,
        showOverlay: false,
      ),
    );
  }
}
