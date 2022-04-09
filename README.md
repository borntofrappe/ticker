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
