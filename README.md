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
