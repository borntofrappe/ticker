# ticker

A trivial counter app.

## Development notes

> for posterity's sake

### Scrolling digits

Use the `ListWheelScrollView` widget to show digits one above the other. The widget requires two fields: `itemExtent` and `children`. In this last property create a list of widget to show the ten numbers.

```dart
children: List<Widget>.generate(
  digits,
  (index) => FittedBox(
    child: Text(
      ('$index'),
    ),
  ),
),
```

`FittedBox` helps to expand the text to stretch to the available space.

### Control

The goal is to ultimately handle the scrolling through two buttons instead of the wheel.

Disable the wheel's scrolling with `physics`.

```dart
ListWheelScrollView(
  physics: const NeverScrollableScrollPhysics(),
)
```

Make the widget into a stateful widget to manage state.

```dart
class Ticker extends StatefulWidget {
}
class _TickerState extends State<Ticker> {
}
```

Initialize a variable for the controller in the subclass of state.

```dart
late FixedExtentScrollController _controller;
```

Set up the controller in the `initState` lifecycle method.

```dart
@override
void initState() {
  super.initState();

  _controller = FixedExtentScrollController();
}
```

Dispose of the resources allocated to the controller through the lifecycle method.

```dart
@override
void dispose() {
  _controller.dispose();

  super.dispose();
}
```

Include the controller in the wheel.

```dart
ListWheelScrollView(
    controller: _controller,
)
```

Modify the widget tree to return the list above a row with two columns, to count up and down.

```text
Column
  Expanded
    Center
      ListWheelScrollView
  Row
    IconButton
    IconButton
```

Add a function to the `onPressed` field to scroll up and down.

```dart
onPressed: () => _scroll(-1),
onPressed: () => _scroll(1),
```

Define `_scroll` to update the wheel through the controller.

```dart
void _scroll(int direction) {
}
```

Retrieve the current value with `_controller.selectedItem` and change it according to the input direction.

```dart
_controller.jumpToItem(
  _controller.selectedItem + 1 * direction
);
```

Use `jumpToItem` to move to the neighboring items instantaneously. Use `animateToItem` to move with an animation instead.

Add the required duration and curve.

```dart
_controller.animateToItem(
    _controller.selectedItem + 1 * direction,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOutSine
);
```

### Infinite scroll

Connected to the list wheel widget you find `ListWheelScrollView.useDelegate` to generate the children programmatically. In the required `childDelegate` field you can use the `ListWheelChildLoopingListDelegate` widget to create an closed wheel, or rather a repeating wheel with the input digits.

```dart
ListWheelScrollView.useDelegate(
  childDelegate: ListWheelChildLoopingListDelegate(
    children: [] // List<Widget>...
  )
)
```

Ultimately, however, I chose not to pursue the looping route. This is more as a matter of preference in terms of the values assumed by the controller in `_controller.selectedItem`, which I'd rather keep in a given range instead of extending to large positive _or_ negative numbers.

Keeping the existing `ListWheelScrollView` widget create a list with one more number than necessary.

```diff
 List<Widget>.generate(digits, )
+List<Widget>.generate(digits + 1,)
```

Remove the excess in the text widget.

```dart
Text(
  (index % digits).toString()
)
```

In the scrolling function directly update the current item directly in the two instances when the selected item falls outside of the list.

```dart
if(direction == -1 && _controller.selectedItem == 0) {
    _controller.jumpToItem(digits);
} else if(direction == 1 && _controller.selectedItem == digits) {
    _controller.jumpToItem(0);
}
```

The illusion works since you jump to the item before you animate the wheel and ultimately hide all numbers except the one displayed in the center — with the `overAndUnderCenterOpacity` property.