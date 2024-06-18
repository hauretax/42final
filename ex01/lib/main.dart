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
        child: TextSwitcher(),
      ),
    ));
  }
}

class TextSwitcher extends StatefulWidget {
  @override
  _TextSwitcherState createState() => _TextSwitcherState();
}

class _TextSwitcherState extends State<TextSwitcher> {
  bool _showInitialText = true;

  void _toggleText() {
    setState(() {
      _showInitialText = !_showInitialText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _showInitialText ? 'Her is the button' : 'Hello World!',
        ),
        ElevatedButton(
          onPressed: _toggleText,
          child: const Text('Click me'),
        ),
      ],
    );
  }
}
