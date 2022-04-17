import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WheelChangeNotifier(),
      child: const App(),
    ),
  );
}

class WheelChangeNotifier extends ChangeNotifier {
  FixedExtentScrollController controller = FixedExtentScrollController();

  void jumpToItem(index) {
    controller.jumpToItem(index);
  }
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const <Widget>[
            Expanded(
              child: Wheel(),
            ),
            Buttons(),
          ],
        ),
      ),
    );
  }
}

class Wheel extends StatelessWidget {
  const Wheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListWheelScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller:
            Provider.of<WheelChangeNotifier>(context, listen: false).controller,
        itemExtent: 200,
        children: List<Widget>.generate(
          10,
          (index) => Item(
            digit: index,
          ),
        ),
      ),
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

class Buttons extends StatelessWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                int index =
                    Provider.of<WheelChangeNotifier>(context, listen: false)
                        .controller
                        .selectedItem;

                Provider.of<WheelChangeNotifier>(context, listen: false)
                    .jumpToItem(index - 1);
              },
              child: const Icon(Icons.remove),
            ),
            ElevatedButton(
              onPressed: () {
                int index =
                    Provider.of<WheelChangeNotifier>(context, listen: false)
                        .controller
                        .selectedItem;

                Provider.of<WheelChangeNotifier>(context, listen: false)
                    .jumpToItem(index + 1);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
