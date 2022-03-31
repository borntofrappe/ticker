# ticker

A trivial counter app.

## TODOS

- [ ] refactor

  - [ ] avoid repeating widgets

  - [ ] initialize variables

- [ ] redesign

  - [ ] consider replacing the icon buttons with text buttons using the `Inter` font

- [ ] scroll

  - [ ] gesture detector

  - [ ] volume keys?

    if so only through a toggle in the settings page, which defaults to disable the feature

- [ ] landscape mode

- [ ] settings page

  - [ ] persist counter

  - [ ] reset counter

  - [ ] jump to a specific number

  - [ ] change the number of digits

  - [ ] (optional) change with volume keys

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

### Multiple wheels

The idea is to ultimately implement a counting feature which exceeds the unit column.

Have the `Ticker` widget receive a named property for the number of columns, with a default value of `3`.

```dart
final int columns;
const Ticker({
  Key? key,
  this.columns = 3,
}) : super(key: key);
```

In the stateful widget create a list of controllers instead of a single instance of `FixedExtentScrollController`.

```dart
late List<FixedExtentScrollController> _controllers;
```

Initialize the multiple controllers in the init function.

```dart
_controllers = List<FixedExtentScrollController>.generate(
  widget.columns,
  (_) => FixedExtentScrollController()
);
```

Dispose of all controllers in the matching lifecycle method.

```dart
for(FixedExtentScrollController controller in _controllers) {
  controller.dispose();
}
```

In the widget tree the idea is to loop through the controllers to add one wheel for each column.

In terms of widget tree wrap `ListWheelScrollView` in an `Expanded` widget. Add the multiple `Expanded` widgets to a row to have the wheel side by side.

```text
Row
  Expanded
    Center
      ListWheelScrollView
  Expanded
    Center
      ListWheelScrollView
```

In the `controller` field add the respective controller, from the looping function.

```dart
_controllers.map(
  (controller) => Expanded(
    child: ListWheelScrollView(
      controller: controller,
    )
  )
).toList()
```

In the `children` field generate a list for each wheel instead of relying on the one created ahead of time.

```dart
children: List<Widget>.generate(
  digits + 1,
  // ...
)
```

Using a single list does not seem to cause issues, at least with a superficial look, but it is reasonable to create a set for each separate wheel.

### Update counter

With multiple columns you need to consider when a digit exceeds the range in either direction.

The idea is to update the `scroll` function to immediately modify the last column, then move backwards if necessary.

Initialize a counter variable to start at the end of the controllers' list.

```dart
int index = _controllers.length;
```

In a `do..while` loop decrement the counter variable — which explains why the initial value is actually off by one.

```dart
do {
  index -= 1;

} while(index > 0);
```

If you were to modify all columns you'd execute the previous logic for every single controller.

```dart
do {
  index -= 1;
  // _controllers[index]
} while(index > 0)
```

To consider only the [0-9] extremes, update the `while` condition considering the selected item and direction.

```dart
while (
  index > 0 &&
  (
    (direction == 1 && _controllers[index].selectedItem == digits - 1)
    ||
    (direction == -1 && _controllers[index].selectedItem == digits)
  )
);
```

In the body of the repeating block log the selected item to double check the value.

### Scroll order

As a matter of preference the application counts numbers by having larger values above smaller ones. One way to achieve the feat is to:

1.  reverse the list of widget describing the numbers

    ```dart
    List<Widget>.generate(
      // digits + 1, ...
    ).reversed.toList()
    ```

2.  flip the input direction in the `_scroll` function

    ```dart
    void _scroll(int direction) {
      direction *= -1;
    }
    ```

3.  reconsider the condition in the `while` statement since the order of the numbers is flipped

### Initial count

In the moment the application stores the count value locally — perhaps through `shared-preferences` — it is helpful to have the stateful widget receive a value for the initial count.

```dart
Ticker(count: 109)
```

Initialize the variable to have the named property optional.

```dart
class Ticker extends StatefulWidget {
  final int count;
  const Ticker({
    Key? key,
    this.count = 0
    // ...
  }) : super(key: key);
}
```

In the subclass of state update the columns through the controllers. Since the logic relies on the `ListWheelScrollView` widgets actually existing include the instructions in the `initState` lifecycle _and_ a function which runs as the widget is built.

```dart
// initialize controllers

WidgetsBinding.instance?.addPostFrameCallback((_) {
    // update controllers
});
```

Note that the order of the numbers in the lists is reversed, so you need to map the individual digits to the corresponding index.

Once you extract the number for each column in a variable `digit`:

- update the controllers to jump at the bottom of the wheel

  ```dart
  _controllers[index].jumpToItem(digits);
  ```

- animate the controllers back to the correct value

  ```dart
  _controllers[index].animateToItem(
      digits - digit,
      // ...
  )
  ```

To compute the digit consider the input count and begin with the last column.

```dart
int count = widget.count;
int index = _controllers.length - 1;
```

In a while loop continue extracting the digit as long as 1. the count is a positive number and 2. there are columns left.

```dart
while(count > 0 && index >= 0) {
}
```

Extract the digit with the modulo operator.

```dart
int digit = count % digits;
```

Once you update the controller update the count and index to eventually exit the loop.

```dart
count = count ~/ digits;
index --;
```

`~/` works as a shorthand for integer division, `(count / digits).toInt()`.

### Staggered animation

The goal is to stagger the scrolling animation, both for successive columns and for the initial count.

For either start with a value describing the total duration and compute the number of milliseconds devoted to each digit.

For successive columns devote up to 600 milliseconds, in case every digit is flipped.

```dart
int duration = 600 ~/ _controllers.length;
```

For the initial count devote up to 2 seconds, since it is ultimately possible to scroll to higher digits and the animation introduces the application.

```dart
int duration = 2000 ~/ _controllers.length;
```

Initialize a variable to keep track of the delay and increment this number with each column, with each digit.

```dart
// successive column
delay += duration ~/ 3;

// initial count
delay += duration - (duration ~/ digits);
```

Consider a smaller amount than the total duration to have successive scrolls take place before the previous instance has had a chance to finish.

Use `Future.delayed` to animate the controller after the prescribed delay.

```dart
Future.delayed(
  Duration(milliseconds: delay),,
  () => // animateToItem
)
```

Most importantly, be sure that the delayed animation actually updates the current controller. This means either extracting the index in a separate variable or the controller itself.

```dart
FixedExtentScrollController controller = _controllers[index];

// later
controller.animateToItem()
```

`index` is updated in the while loop so that using the variable would mean the method would be applied on the last available instance.

```diff
-_controllers[index].animateToItem()
```

### Design

A few updates following the sketch introducing this project.

![](https://github.com/borntofrappe/ticker/blob/main/ticker.png)

- finally hide the digits above the and below the current one.

- add a border, but only around the digit displayed in the center, by creating a stack and overlaying a decorative list wheel. Wrap the widget in `ExcludeSemantics` to remove the tree from the accessibility tree.

- wrap the buttons in `Material` and `Ink` widgets to change the overall shape

- limit the height of the column to have the wheels and buttons closer

- use `flex` properties to separate the height between wheels and buttons

- add a custom font in place of the default family

- update colors with a more subdued hex color
