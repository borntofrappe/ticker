import 'package:flutter/material.dart';
import 'package:ticker/widgets/custom_button.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final Function onChanged;
  final bool value;
  final Widget title;
  final Widget? subtitle;
  final double checkboxSize;
  final double iconSize;
  final double borderWidth;
  final IconData icon;

  const CustomCheckboxListTile({
    Key? key,
    required this.onChanged,
    this.value = false,
    required this.title,
    this.subtitle,
    this.checkboxSize = 24.0,
    this.iconSize = 18.0,
    this.borderWidth = 1.0,
    this.icon = Icons.close,
  }) : super(key: key);

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  bool _value = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _value = widget.value;
    });
  }

  void _updateValue() {
    setState(
      () {
        _value = !_value;
      },
    );
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    Widget title = widget.title;
    Widget? subtitle = widget.subtitle;
    double checkboxSize = widget.checkboxSize;
    double iconSize = widget.iconSize;
    double borderWidth = widget.borderWidth;
    IconData icon = widget.icon;

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
        child: _value
            ? Padding(
                padding: EdgeInsets.all((checkboxSize - iconSize) / 2),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Container(),
        size: checkboxSize,
        borderWidth: borderWidth,
        showOverlay: false,
      ),
    );
  }
}
