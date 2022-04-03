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

Just change the `fontSize` and `size` properties respectively to have the visuals expand as wanted. Also consider toying with the padding added by default on the outlined button. This directly in the button theme.

```dart
style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.all(0.0),
)
```
