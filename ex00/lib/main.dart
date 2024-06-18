import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Her is the button',
            ),
            ElevatedButton(
                onPressed: () {
                  print('clicked');
                },
                child: const Text('Click me')),
          ],
        ),
      ),
    ));
  }
}
