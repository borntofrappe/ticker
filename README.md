# Ticker

A trivial counter app.

## demos

Following the rough sketch provided in `ticker.png` I develop parts of the larger applications in the `demos` folder.

![](https://github.com/borntofrappe/ticker/blob/main/ticker.png)

_Please note:_ the design might change as I find more interesting solutions.

### squared_outlined_button

The application is meant to have squared, outline buttons which mirror the design of the digits making up the counter. For this:

- use `OutlinedButton`

- customize the appearance of the button through an instance of the `Theme` widget

- force a specific width and height with a `SizedBox` widget

- force the squared shape with an `AspectRatio` widget

- enlarge the text to fit in the resulting square with a `FittedBox` widget

There is undoubtedly a better solution, but the one in `demos/squared_outlined_button.dart` works.

Whatsmore, the widget allows for some type of customization in terms of the content _inside_ of the outlined buttons. For the application this means it is possible to add text:

```dart
child: const Text(
  '+',
  style: TextStyle(
    fontSize: 64.0,
  ),
),
```

Or again an icon:

```dart
child: const Icon(
  Icons.chevron_right,
  size: 64.0,
),
```

Just change the `fontSize` and `size` properties respectively to have the visuals expand as wanted.

### slideToRoute

The application is meant to have two screens, home page and settings. To move to and from the settings' page the goal is to have the visual slide from the right side, explaining the need for a custom page builder.

`slideToRoute` returns an instance of `PageRouteBuilder` for the input widget following the example of [_Animate a page route transition_](https://docs.flutter.dev/cookbook/animation/page-route-animation) from Flutter's own cookbook.

Once you have the function define the transition in the `onGenerateRoute` field of the material application and for the prescribed route.

The builder is used as the application uses `Navigator.pushNamed`.

### toggle

In the settings page one of the options is to toggle the ability to save the counter as the app is closed and destroyed. To enable this option create `Toggle` as a stateful widget using `SwitchListTile` _or_ `CupertinoSwitch`. The choice between the two is up to the operating system, android and ios respectively.

For android the documentation instructs a widget similar to `ListTile`, with a title, subtitle properties on top of the required `value` and `onChanged` fields.

For ios `CupertinoSwitch` adds only the toggle, not the entire tile. For this reason wrap the widget in a `ListTile`, itself resposible for the horizontal spread.

### wheel

As the user presses the buttons in the bottom section of the home screen the goal is to have numbers scroll vertically to update the count. In the application I intend to implement the scrolling feature with a `ListWheelScrollView` and a dedicated controller, but the demo works to show how the widget and its two required properties operate. `itemExtent` explains the height devoted to the individual items, `children` provides the list of widgets to show one above the other.

In terms of appearance show the individual items in a squared container — through `AspectRatio`, and with a solid border — although ultimately the border is meant to highlight only the center value.

### wheels

To consider numbers beyond the unit column add multiple wheels side by side. The demo highlights an issue with the choice of using a hard-coded value for the `itemExtent` property: in the moment the screen's width is not able to fit all the squared containers the aspect ratio is compromised to have the height of the items preserved.

One way to fix this issue is to consider the available space and computing the value on the basis of the number of wheels. This explains the use of the `MediaQuery` object to consider the width of the screen and the computation of `itemExtent` which follows.

### window

As prefaced in the demo devoted to a single wheel the goal is to show a solid border only around the center item. One solution is to have a `Stack` widget with two overlapping wheels. In one wheel add the digits, in the other wheel add a single item to create the outline.

_Please note:_ in the demo the wheel for the border precedes the one dedicated to the numbers, to preserve the scrolling. This means the border is actually behind the digits. In the moment you disable physics scrolling and manage the wheel with a controller it is reasonable to swap the two widgets.

### intro_animation

As a form of splash screen the goal is to show the name of the application in a similar scroll as the one used for the digits.

Instead of moving the letters top to bottom, however, the idea is to have the animation side to side. This mirrors the position of the letters and is helpful to move to the home screen similarly to how the home screen moves to the settings page.

For the horizontal wheel rotate the entire list a quarter turn back, the list items a quarter turn forward to keep them straight up.

## App

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

In the scrolling function directly update the current item in the two instances when the selected item falls outside of the list.

The illusion works since you jump to the item before you animate the wheel and ultimately hide all numbers except the one displayed in the center.

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

In the moment the application stores the count value locally it is helpful to have the stateful update the controllers on the basis of a counter variable.

Since the logic relies on the `ListWheelScrollView` widgets actually existing include the instructions in the `initState` lifecycle _and_ a function which runs as the widget is built.

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
int value = widget.value;
int index = _controllers.length - 1;
```

In a while loop continue extracting the digit as long as 1. the count is a positive number and 2. there are columns left.

```dart
while(value > 0 && index >= 0) {
}
```

Extract the digit with the modulo operator.

```dart
int digit = value % digits;
```

Once you update the controller update the count and index to eventually exit the loop.

```dart
value = value ~/ digits;
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

### Font features

When using the chosen font the squared, outlined button has the unfortunate burden of the family's x-height. To align the characters vertically, specifically the plus and minus sign, it is however possible to benefit from one of the font's features

1. import `dart:ui`

2. enable [case sensititive forms](https://api.flutter.dev/flutter/dart-ui/FontFeature/FontFeature.caseSensitiveForms.html)

### Toggle

In the application it is `settings.dart` which manages the state of the toggle. In light of this it seems reasonable to have the toggle widget be a stateless one.

In terms of UI, accompany the toggle with a snackbar. The visual is helpful to notify the user of how the preference has been changed with immediate effect.
