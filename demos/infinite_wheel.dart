import 'package:flutter/material.dart';

const int _digits = 10;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black87,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ReversedWheel(),
        // child: Wheel(),
        // child: LoopingWheel(),
      ),
    );
  }
}

class Wheel extends StatefulWidget {
  const Wheel({Key? key}) : super(key: key);

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _scroll(int direction) {
    int selectedItem = _controller.selectedItem;
    if (selectedItem == 0 && direction == -1) {
      _controller.jumpToItem(_digits);
    } else if (selectedItem == _digits && direction == 1) {
      _controller.jumpToItem(0);
    }

    _controller.jumpToItem(_controller.selectedItem + 1 * direction);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _scroll(-1);
                },
                child: const Text('Decrement'),
              ),
              const SizedBox(width: 32.0),
              TextButton(
                onPressed: () {
                  _scroll(1);
                },
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListWheelScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            itemExtent: 200,
            children: List<Widget>.generate(
              _digits + 1,
              (index) => Item(
                digit: index % _digits,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoopingWheel extends StatefulWidget {
  const LoopingWheel({Key? key}) : super(key: key);

  @override
  State<LoopingWheel> createState() => _LoopingWheelState();
}

class _LoopingWheelState extends State<LoopingWheel> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _scroll(int direction) {
    _controller.jumpToItem(_controller.selectedItem + 1 * direction);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _scroll(-1);
                },
                child: const Text('Decrement'),
              ),
              const SizedBox(width: 32.0),
              TextButton(
                onPressed: () {
                  _scroll(1);
                },
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            childDelegate: ListWheelChildLoopingListDelegate(
              children: List<Widget>.generate(
                _digits,
                (index) => Item(
                  digit: index,
                ),
              ),
            ),
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            itemExtent: 200,
          ),
        ),
      ],
    );
  }
}

class ReversedWheel extends StatefulWidget {
  const ReversedWheel({Key? key}) : super(key: key);

  @override
  State<ReversedWheel> createState() => _ReversedWheelState();
}

class _ReversedWheelState extends State<ReversedWheel> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _scroll(int direction) {
    direction *= -1;

    int selectedItem = _controller.selectedItem;
    if (selectedItem == 0 && direction == -1) {
      _controller.jumpToItem(_digits);
    } else if (selectedItem == _digits && direction == 1) {
      _controller.jumpToItem(0);
    }

    _controller.jumpToItem(_controller.selectedItem + 1 * direction);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _scroll(-1);
                },
                child: const Text('Decrement'),
              ),
              const SizedBox(width: 32.0),
              TextButton(
                onPressed: () {
                  _scroll(1);
                },
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListWheelScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            itemExtent: 200,
            children: List<Widget>.generate(
              _digits + 1,
              (index) => Item(
                digit: index % _digits,
              ),
            ).reversed.toList(),
          ),
        ),
      ],
    );
  }
}

class Item extends StatelessWidget {
  final int digit;
  const Item({required this.digit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 8.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: FittedBox(
          child: Text('$digit'),
        ),
      ),
    );
  }
}
