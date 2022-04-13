# Ticker

A trivial counter app.

## demos

### wheel

As the user presses the buttons in the bottom section of the home screen the goal is to have numbers scroll vertically to update the current count. In the application I intend to implement the scrolling feature with a `ListWheelScrollView` and a dedicated controller, but the demo works to show how the widget and its two required properties operate. `itemExtent` explains the height devoted to the individual items, `children` provides the list of widgets to show one above the other.

In terms of appearance show the individual items in a squared container — through `AspectRatio`, and with a solid border — although ultimately the border is meant to highlight only the center value.

### wheels

To consider numbers beyond the unit column add multiple wheels side by side. The demo highlights an issue with the choice of using a hard-coded value for the `itemExtent` property: in the moment the screen's width is not able to fit all the squared containers the aspect ratio is compromised to have the height of the items preserved.

One way to fix this issue is with `LayoutBuilder`. The widget provides box constraints and most importantly the maximum width and height. Use the minimum between the two together with a hard-coded default value to compute the item extent.

### window

As prefaced in the demo devoted to a single wheel the goal is to show a solid border only around the center item. One solution is to have a `Stack` widget with two overlapping wheels. In one wheel add the digits, in the other wheel add a single item to create the outline.

Wrap this last widget in `ExcludeSemantics` given the purely decorative reasoning behind the component.

_Please note:_ in the demo the wheel for the border precedes the one dedicated to the numbers, to preserve the scrolling. This means the border is actually behind the digits. In the moment you disable physics scrolling and manage the wheel with a controller it is reasonable to swap the two widgets.

### change_notifier

As prefaced in the demo devoted to a single wheel the goal is to update the wheels with two separate buttons. It is possible to create a single giant widget which renders the wheel _and_ button in the same `build` method, managing the logic for both, but it is ultimately helpful to break the application into multiple widgets. In this instance the change notifier helps to update the interface from the separate location.

### infinite_wheel

The wheels are ultimately managed with a controller. The demo shows how to implement the wheel always showing numbers in a given range — 0 to 9 — in two possible ways:

1. with a looping wheel relying on the `ListWheelChildLoopingListDelegate` widget

2. with a regular wheel with one more item than necessary. Since the application is managed with a controller the idea is to immediately jump to either end of the list before animation.

I ultimately prefer the second option since the index in the scrolling widget is then limited to a given range. In the first instance the index might become exceedingly small or large as the wheel continues producing items in a given direction.

With this in mind the application is meant to show higher numbers above lower values. One way to achieve the desired layout is by:

1. reversing the list describing the digits

2. swapping the direction for the controller

The added difficulty comes in the form of the index referring to the selected item. As the wheel moves upwards, toward greater values as it were, the index becomes smaller.

Display the selected item to debug the interfance.

```dart
print(_controller.selectedItem);
```

### splash_screen

As a form of splash screen the goal is to show the name of the application with a similar design as the one implemented for the digits.

Instead of moving the letters top to bottom, however, the idea is to have the animation side to side. This helps to perceive the letters and mirrors how the application will then move to the settings page — refer to the `slideToRoute` demo.

For the horizontal wheel rotate the entire list a quarter turn back, the list items a quarter turn forward to keep them straight up.

### slideToRoute

Past the splash screen the application is meant to have two screens, home page and settings. To move to and from the settings' page the goal is to have the visual slide from the right side, explaining the need for a custom page builder.

`slideToRoute` returns an instance of `PageRouteBuilder`. Once you have the function define the transition in the `onGenerateRoute` field of the material application and for the prescribed route.

The builder is used as the application uses `Navigator.pushNamed`.

### custom_button

The application relies on several buttons to update the counter, move to the settings page and again update the application's preferences. To mirror the design of the wheels' digits the goal is to have squared buttons with a solid border.

The demo shows how to implement the desired design with an `OutlinedButton` and the `style` property. The widget tree should allow to include an icon or text widget as a child, expanding the size of either visual to the container's size. If you need a smaller visual wrap the `child` in a `Padding` widget.

_Please note:_ the demo uses the color from the theme for the color of the border, but **not** for the color of the text or icon. The style of these last two elements is outside of the scope of the button.

### custom_checkbox

In the settings page the application allows to customize preferences with several widgets, among which a checkbox to save the counter locally. The goal of the demo is to show how to use the custom button designed for the application to toggle between the two options. The widget also receives a function which is called with the updated value, so that ultimately the parent widget is able to enact the desired feature.

### custom_checkbox_list_tile

In the settings page the checkbox is actually slotted in a list tile. The demo shows how to fit the custom button in a `ListTile` fabricating a similar solution to `CheckboxListTile`. The functionality of the checkbox is associated with a press on the button or a tap on the list tile.

### custom_range_list_tile

In the settings page one of the options allows to change the number of column by tapping on a counter button. The demo shows how to fit the custom button in a `ListTile` widget and update the child to show the desired number.

## App

Following the projects in the `demos` folder the application is developed in the `lib` directory. In increments.

### Fonts

In the `fonts` folder add the family chosen for the project. Reference the files in `pubspec.yaml` and the font at app level.

```dart
return MaterialApp(
  theme: ThemeData(
    fontFamily: 'Inter',
  )
);
```

### Splash sreen

Start by adding the splash screen widget in an instance of material app. Define a primary color through `ThemeData` so that the value is picked up by widget.

### Navigation

Add the function producing the sliding animation to move from the splash screen to the home widget.

In splash screen use `Navigator.pushReplacementNamed` to remove the widget only after the animation finishes.

To test the function add also a button to move between the home screen and settings' page. This time use `Navigator.pushNamed` to have the home widget persist below the new route.

_Please note:_ it is likely the flow of the application might change as I further develop the page devoted to the settings.

### Home

Start with the design of the home screen divving up a column in three sections:

1. navigation, with a button to move to the settings' page

2. wheels, with the `ListWheelScrollView` widgets — currently in a fixed number and without the associated controller. The idea is to focus on the appearance only

3. buttons, with the buttons ultimately updating the counter — currently with an empty `onPressed` field

A note on the buttons: import `dart:ui`. The library helps to vertically align the plus and minus sign used in the buttons with the custom font.

```dart
fontFeatures: [
  FontFeature.caseSensitiveForms(),
],
```

### Change notifier

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

Wrap the widgets describing the wheels and the buttons in a `ChangeNotifierProvider` so that both components have access to the list.

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

### Scrolling

In the instance of `ChangeNotifier` describe how to update the wheels with a `scroll` method. The functionality is similar to the `infinite_wheel.dart` demo, but is expanded to consider all the existing digits, from the unit to the tens to the hundreds.

The idea is to start from the last column, update the item and if the number exceeds the range, in either direction, repeat the process for the preceding set.

### Initial scroll

In the moment the application stores the count value locally it is helpful to have the stateful widget update the controllers on the basis of an input variable.

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

### Staggered animation

The goal is to stagger the scrolling animation, both for successive columns and for the initial count.

For either start with a value describing the total duration and compute the number of milliseconds devoted to each digit.

For successive columns devote up to 500 milliseconds, in case every column is updated.

```dart
int duration = 500 ~/ _controllers.length;
```

For the initial count devote up to 2 seconds, since it is ultimately possible to scroll to higher digits and the animation introduces the application.

```dart
int duration = 2000 ~/ _controllers.length;
```

_Please note:_ the duration and curves might change as I test the application on an actual device.

Initialize a variable to keep track of the delay and increment this number with each column, with each digit.

```dart
// successive column
delay += duration ~/ 3;

// initial count
delay += duration - (duration ~/ 2);
```

Consider a smaller amount than the total duration to have successive scrolls take place before the previous instance has had a chance to finish.

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

### Settings

In terms of design add an icon to move back to the home screen, a list tile with the name of the application and an additional list tile to preface the app prefernces.

Include the app preferences in a `ListView` widget with a series of dedicated components. Since

### Shared preferences

Install the library to manage app preferences and optionally save the counter as the app is terminated and opened anew.

Use the library immediately in the splash screen to optionally reduce the animation.

```dart
final preferences = await SharedPreferences.getInstance();
final bool shortOnTime = preferences.getBool('short-on-time') ?? false;
```

In the settings page update the preferences as the checkbox are toggled.

```dart
void setBoolPreference(String key, bool? value) async {
  final preferences = await SharedPreferences.getInstance();
  preferences.setBool(key, value ?? false);
}
```

As the settings page is first created you need to also retrieve the preferences _and_ update the state of the checkboxes. Set the state from the parent widget.

```dart
void getBoolPreferences() async {
  final preferences = await SharedPreferences.getInstance();
  setState(
    () {
      _shortOnTime = preferences.getBool('short-on-time') ?? false;
    },
  );
}
```

Update the state in the child widget through the `didUpdateWidget` lifecycle method.

```dart
@override
void didUpdateWidget(oldWidget) {
  super.didUpdateWidget(oldWidget);
  setState(() {
    _value = widget.value;
  });
}
```

### Save scroll value

Storing the value described by the wheels is more complex than toggling a boolean variable to condition the initial animation. This is because it should be possible to save the value both in the home and in the settings page, as the preference is ultimately toggled.

Create `ScreenArguments` as a utility class — relevant as you pass arguments between routes.

```dart
class ScreenArguments {
  int scrollValue;

  ScreenArguments({
    required this.scrollValue,
  });
}
```

In the `onGenerateRoute` field of the material app move to the settings page extracting the scroll value from the arguments of the home page.

```dart
final args = settings.arguments as ScreenArguments;
return slideToRoute(
  Settings(
    scrollValue: args.scrollValue,
  ),
);
```

Regardless of how the value is computed — refer to a later section — pass the integer from the home page in `Navigator.pushNamed`.

```dart
Navigator.pushNamed(
  context,
  '/settings',
  arguments: ScreenArguments(
    scrollValue: scrollValue,
),
```

In the settings page receive the value in the stateless widget, with the ultimate idea of passing the integer to `Preferences` and save the number in shared preferences if the matching checkbox is toggled.

In the home page it is then necessary to save the value as the scroll position is changed. The approach might change in the future, but the current idea is to wait for the scroll animation to end and call a function to optionally save the value.

Mirroring this action, and always in the home screen, it is finally necessary to retrieve the value as the page is first created. Again this action is optional and conditional to the user having selected the desired checkbox.

To compute the scroll value the process is fundamentally the opposite of the one used to set the digits based on the initial count. Start by the last column and increment a counter variable, multiplying the digit by 1, 10, 100 on the basis of the column.

As a form of optimization, and instead of checking shared preferences every time the scroll takes place, initialize a boolean variable in the instance of the change notifier.

```dart
bool _isSavingScrollValue = false;
```

The goal is to then update the value in two instances:

- as the home screen is first initialized, considering shared preferences

- as the settings screen is popped, since the preference can change with the matching checkbox

For the settings page you also need to handle when the page is removed with the back button. Flutter provides `WillPopScope`. In the `onWillPop` retrieve and return the preference as in the button included in the page.

With the updated value the scrolling function needs to check the boolean instead of always referring to shared preferences.

### Home again

From the settings page the idea is to create a new counter by pushing the `Home` widget on the settings page and then remove all existing routes. The feat is achieved with `Navigator.pushNamedAndRemoveUntil`, specifically with a predicate function which always returns `false`.

Since the counter is supposed to be new initialize the home screen with a scroll value of zero. Moreover, if the instance of shared preferences describes that the user wants to remember the counter, override the value with the new number.
