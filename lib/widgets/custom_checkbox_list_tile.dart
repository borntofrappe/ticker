import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final bool value;
  final Function onChanged;
  final Widget title;
  final Widget? subtitle;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.value = false,
    required this.onChanged,
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(
          () {
            _value = !_value;
            widget.onChanged(_value);
          },
        );
      },
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(const Size(24.0, 24.0)),
          maximumSize: MaterialStateProperty.all(const Size(24.0, 24.0)),
          shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.black87,
              width: 1.0,
            ),
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: _value
            ? const Center(
                child: Icon(
                  Icons.close,
                  size: 18.0,
                  color: Colors.black87,
                ),
              )
            : Container(),
        onPressed: () {
          setState(
            () {
              _value = !_value;
              widget.onChanged(_value);
            },
          );
        },
      ),
    );
  }
}
