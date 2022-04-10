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

### splash_screen

As a form of splash screen the goal is to show the name of the application with a similar design as the one implemented for the digits.

Instead of moving the letters top to bottom, however, the idea is to have the animation side to side. This helps to perceive the letters and mirrors how the application will then move to the settings page — refer to the `slideToRoute` demo.

For the horizontal wheel rotate the entire list a quarter turn back, the list items a quarter turn forward to keep them straight up.

### slideToRoute

Past the splash screen the application is meant to have two screens, home page and settings. To move to and from the settings' page the goal is to have the visual slide from the right side, explaining the need for a custom page builder.

`slideToRoute` returns an instance of `PageRouteBuilder`. Once you have the function define the transition in the `onGenerateRoute` field of the material application and for the prescribed route.

The builder is used as the application uses `Navigator.pushNamed`.

### custom_button

The application relies on several buttons to update the counter, move to the settings page and again update the application's preferences. To mirror the design of the wheels the goal is to have squared buttons with a rectangular border.

It is possible to implement the design with and `ElevatedButton` or again with an `OutlinedButton`, and the demo shows how. The choice between the two is debatable. The material API describes elevated button as a primary button, with the biggest emphasis. Is the connotation purely a matter of design or semantics? Should primary buttons be elevated, secondary buttons outlined? Since the design of the buttons in the application is the same for all buttons it might be acceptable to rely on a single widget.

In terms of implementation I lean toward outlined button, since the widget has a border by default and requires less code to change the starting assumptions — see elevation and shadow color.

### custom_checkbox

In the settings page the application allows to customize preferences with several widgets, among which a checkbox to save the counter locally. It would be possible to use a `Switch` or `Checkbox` widget, but I ultimately prefer to follow the example and design of the custom button. The demo shows how to implement a toggle with a stateful widget which renders the child widget pending a boolean condition. The widget also receives a function which is called with the updated value, so that ultimately the parent widget is able to enact the desired feature.

Out of preference I've chosen to remove the overlay color.

### infinite_wheel

The wheels are ultimately managed with a controller. The demo shows how to implement the wheel always showing numbers in a given range — 0 to 9 — in two possible ways:

1. with a looping wheel relying on the `ListWheelChildLoopingListDelegate` widget

2. with a regular wheel with one more item than necessary. Since the application is managed with a controller the idea is to immediately jump to either end of the list before animation.

I ultimately prefer the second option since the index in the scrolling widget is then limited to a given range. In the first instance the index might become exceedingly small or large as the wheel continues producing items in a given direction.

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
