# Ticker

A trivial counter app.

## Feature

Press one of two buttons to update a counter in the [0-999] range.

## App preferences

- save the counter as the app is terminated

- reduce the duration of the initial animation

- add color from a few options

## Counter preferences

Change the number of columns and the counter's range.

## Development

> for posterity's sake

This project has been developed starting from the static assets in the `res` folder, with the contribution of small, independent projects in the `demo` sub-directory.

### wheel

> display numbers in the 0-9 range one above the other

Use `ListWheelScrollView` specifying the two required properties:

1. `itemExtent` , the height devoted to the individual items

2. `children`, the list of widgets to show one above the other

For the individual item show the numbers in a squared container — through `AspectRatio`, and with a solid border — although ultimately the border is meant to highlight only the center value.

### wheels

> display multiple wheels side by side

In the moment the screen's width is not able to fit all the squared containers the aspect ratio is compromised to have the height of the items preserved.

Use `LayoutBuilder` to retrieve box constraints and most importantly the maximum width and height. Use the minimum between the two together with a hard-coded default value to compute the item extent.

### window

> only show the center item in a frame

Use a `Stack` widget with two overlapping wheels. In one wheel add the digits, in the other wheel add a single item to create the outline.

_Please note:_ in the demo the wheel for the border precedes the one dedicated to the numbers, to preserve the scrolling. This means the border is actually behind the digits. In the moment you disable physics scrolling and manage the wheel with a controller it is reasonable to swap the two widgets.

_Please also note:_ in the final application the layout was updated to use the list wheel widget only for the numbers. Knowing the size of the items, through `itemExtent`, it is enough to use a `Container` with a fixed size.

### wheel_change_notifier

> manually update the wheel

It is possible to create a single giant widget which renders the wheel _and_ button in the same `build` method, managing the logic for both. Ultimately, however, I chose to break the application into multiple widgets.

Use an instance of change notifier to update the interface from the separate location.

### wheel_closed

> create a closed wheel looping numbers in the 0-9 range

Create a closed wheel in one of two ways:

1. with a looping wheel relying on the `ListWheelChildLoopingListDelegate` widget

2. with a regular wheel with one more item than necessary. Since the application is ultimately managed with a controller, then, immediately jump to either end of the list before updating the wheel

I ultimately prefer the second option since the index in the scrolling widget is then limited to a given range. In the first instance the index might become exceedingly small or large as the wheel continues producing items in a given direction.

### wheel_reversed

> show larger numbers above smaller ones

From the regular wheel:

1. reverse the list describing the digits

2. swap the direction in the controller

The added difficulty comes in the form of the index referring to the selected item. As the wheel moves upwards, toward greater values as it were, the index becomes smaller.

Display the selected item to debug the interfance.

```dart
print(_controller.selectedItem);
```

### wheel_final

> update the design of the closed, reversed wheel

Knowing the `itemExtent` create a layered structure to guarantee a solid background and a border but only for the item in the center of the wheel.

Creating separate components for the decorations, the background and the border, also allows the individual `Item` widget to be simplified considerably. The only purpose of `Item` is to render the input child widget in a squared, fitted box.

### splash_screen

> introduce the application with a small animation

Show the name of the application with a similar design as the one implemented for the wheel.

Animate the letters side to side. This helps to perceive the letters and better fits how the application will then move between routes.

Use `RotatedBox` to rotate the entire wheel, repeat `RotatedBox` to have the letters rightside up.

### slideToRoute

> move between routes sliding pages horizontally

With `slideToRoute` return an instance of `PageRouteBuilder`. With the function define the transition in the `onGenerateRoute` field of the material application and for the prescribed route.

The builder is used as the application uses `Navigator.pushNamed`.

### custom_button

> design a squared button with a solid border

The widget tree should allow to include an icon or text widget as a child, expanding the size of either visual to the container's size. If you need a smaller visual wrap the `child` in a `Padding` widget.

_Please note:_ the demo uses the color from the theme for the color of the border, but **not** for the color of the text or icon. The style of these last two elements is outside of the scope of the button.

### custom_checkbox

> include the custom button in a checkbox-like widget

Pass a function to the widget to call with the updated value, so that ultimately the parent widget is able to implement the connected logic.

### custom_checkbox_list_tile

> include the custom button in a CheckboxListTile-like widget

_Please note:_ the demo is essentially a rewrite of [custom_checkbox](#customcheckbox) so that it is possible to consider a press on the custom button, a tap on the parent `ListTile`.

### custom_range_list_tile

> repeat the design of the custom checkbox list tile with a button iterating through values

### custom_range_list

> create a button which loops through a list of widgets as the button is pressed

_Please note:_ the demo is essentially a rewrite of [custom_range_list_tile](#customrangelisttile) to produce a widget with a more general purpose.

_Please also note:_ the demo is made less relevant by [theme_change_notifier](#themechangenotifier).

### theme_change_notifier

> change a few color values at the press of a button

In the instance of `MaterialApp` change the overall appearance with an instance of `ThemeData`. With an instance of change notifier update the theme as a button is pressed.

_Please note:_ as it is possible to show the change in color through the build context it is not necessary to create a custom button to cycle through the color values. This makes the rewrite [custom_range_list](#customrangelist) less relevant.

### App specificities

#### Splash screen

For the splash screen use `Navigator.pushReplacementNamed` to remove the widget only after the animation finishes

#### Font features

For the home screen import `dart:ui` to vertically align the plus and minus sign used in the buttons with the custom font

```dart
fontFeatures: [
  FontFeature.caseSensitiveForms(),
],
```

#### Wheels change notifier

I am positive the approach is flawed, but it works. The challenge with respect to the smaller project in the demos folder is that there are multiple wheels, multiple controllers.

Define the class which extends `ChangeNotifier` with an empty list of controllers.

```dart
class WheelsChangeNotifier extends ChangeNotifier {
  List<FixedExtentScrollController> _controllers = [];
}
```

Define a method to populate the list with actual controllers.

```dart
void initialize(List<FixedExtentScrollController> controllers) {
  _controllers = [];
  for (FixedExtentScrollController controller in controllers) {
    _controllers.add(controller);
  }
}
```

Assigning an empty list first works to remove existing references to controllers, but not controllers. This is because the actual instances are handled in the stateful component making up the wheels.

Wrap the widgets describing the home screen in `ChangeNotifierProvider` so that all components have access to the list.

```dart
child: ChangeNotifierProvider(
  create: (_) => WheelsChangeNotifier(),
  child: Column(
    // wheels and buttons
  )
)
```

Make the widget devoted to the wheels a stateful widget. Here, initialize a list of controllers for the actual lists.

```dart
class _WheelsState extends State<Wheels> {
  List<FixedExtentScrollController> _controllers = [];
}
```

In the `initState` lifecycle initialize the controllers and pass them to the individual wheel widgets to manage the scrolling. This is not difference from the `infinite_wheel` demo.

What is different is that in the `build` method you use the provider to add the controllers in the separate list.

```dart
Provider.of<WheelsChangeNotifier>(context, listen: false).initialize(_controllers);
```

The list is updated so that finally the buttons are able to reference the controllers from the separate widget.

```dart
onPressed: () {
  Provider.of<WheelsChangeNotifier>(context, listen: false)._controllers[0]; // do something
},
```

#### Scrolling

In the instance of `ChangeNotifier` describe how to update the wheels with a `scroll` method. The functionality is similar to the `wheel_infinite.dart` demo, but is expanded to consider all the existing digits, from the unit to the tens to the hundreds.

Start from the last column, update the item and if the number exceeds the range, in either direction, repeat the process for the preceding set.

#### Initial scroll

Update the controllers on the basis of an input variable.

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
  _controllers[index].jumpToItem(_digits);
  ```

- animate the controllers back to the correct value

  ```dart
  _controllers[index].animateToItem(
      _digits - digit,
      // ...
  )
  ```

To compute the digit consider the input value and begin with the last column.

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
int digit = value % _digits;
```

Once you update the controller update the count and index to eventually exit the loop.

```dart
value = value ~/ _digits;
index --;
```

`~/` works as a shorthand for integer division, `(count / digits).toInt()`.

#### Staggered animation

Stagger the scrolling animation, both for successive columns and for the initial count.

Initialize a variable to keep track of the delay and increment this number with each column, with each digit.

```dart
scrollDelay += scrollDurationPerItem ~/ 3;

scrollDelay += scrollDurationPerWheel ~/ 2;
```

Consider a smaller amount than the total duration to have successive scrolls take place before the previous instance has a chance to finish.

Use `Future.delayed` to animate the controller after the prescribed delay.

```dart
Future.delayed(
  Duration(milliseconds: delay),,
  () {
    // animateToItem
  }
);
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

#### ScreenArguments

Create `ScreenArguments` as a utility class — relevant as you pass arguments between routes.

In the `onGenerateRoute` field of the material app move to the settings page extracting the scroll value from the arguments of the home page.

#### Shared preferences

Use the library immediately in the splash screen to optionally reduce the animation and possibly retrieve the current count. Pass this value to the home route.

In the settings page update the preferences as the checkbox are toggled, as the buttons are pressed.

#### Save scroll value

The settings page receives the scroll value from the home route. Save the integer as the matching matching checkbox is checked.

In the home page save the value as the scroll position changes. The approach might change in the future, but the current idea is to wait for the scroll animation to end and call a function to optionally save the value.

To compute the scroll value the process is fundamentally the opposite of the one used to set the digits based on the initial count. Start by the last column and increment a counter variable, multiplying the digit by 1, 10, 100 on the basis of the column.

As a form of optimization, and instead of checking shared preferences every time the scroll takes place, initialize a boolean variable in the instance of the change notifier.

```dart
bool _isSavingScrollValue = false;
```

The goal is to then update the value in two instances:

- as the home screen is first initialized, considering shared preferences

- as the settings screen is popped, since the preference can change with the matching checkbox

For the settings page you also need to handle when the page is removed with the back button. Use `WillPopScope` and return the preference in the `onWillPop` callback.

With the updated value the scrolling function needs to check the boolean instead of always referring to shared preferences.

#### Counter preferences

In the settings page allow to start a new counter by essentially creating a new instance of the home screen. Use `Navigator.pushNamedAndRemoveUntil`, specifically with a predicate function which always returns `false` to add the new route above the settings' page and then remove all previous widgets.

#### Theming

Save the index describing the theme through shared preference and directly in the instance of the change notifier/provider.

With the saved value retrieve the index, but only in the splash screen. The idea is to show the default colors up until the application moves to the home screen.

```dart
void _goToHomeRoute() async {
  await Provider.of<ThemeDataChangeNotifier>(widget.context, listen: false).retrieveIndexTheme();

  // move to home route
}
```

Pass the build context to the splash screen from `main.dart`.
