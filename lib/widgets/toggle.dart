import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Toggle extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final bool value;
  final Function onChanged;

  const Toggle({
    Key? key,
    required this.title,
    this.subtitle,
    this.value = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? ListTile(
            title: title,
            subtitle: subtitle,
            trailing: CupertinoSwitch(
              value: value,
              onChanged: (bool value) {
                onChanged(value);
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            onTap: () {
              onChanged(!value);
            },
          )
        : SwitchListTile(
            title: title,
            subtitle: subtitle,
            value: value,
            onChanged: (bool value) {
              onChanged(value);
            },
            activeColor: Theme.of(context).primaryColor,
          );
  }
}
