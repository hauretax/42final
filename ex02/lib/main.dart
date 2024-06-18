import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<String> buttons = [
    "7",
    "8",
    "9",
    "C",
    "AC",
    "4",
    "5",
    "6",
    "+",
    "-",
    "1",
    "2",
    "3",
    "*",
    "/",
    "0",
    ".",
    "00",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = (orientation == Orientation.portrait) ? 5 : 10;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Super Calculator 3000'),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 177, 177, 177),
                child: const FractionallySizedBox(
                  widthFactor: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        Text("0"),
                        Text("0"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color.fromARGB(255, 185, 185, 185),
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  children: buttons.map((text) => buildButton(text)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextButton(
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.resolveWith((states) {
              return const Size(20, 20);
            }),
            padding: WidgetStateProperty.resolveWith((states) {
              return const EdgeInsets.all(16.0);
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return const Color.fromARGB(255, 255, 255, 255);
            }),
          ),
          onPressed: () {
            print('button pressed: $text');
          },
          child: Text(
            text,
            style:
                const TextStyle(fontSize: 15, overflow: TextOverflow.visible),
          )),
    );
  }
}
