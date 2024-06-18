import 'dart:ffi';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const List<String> buttons = [
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Super Calculator 3000'),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
        ),
        body: Calculator(),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "0";
  String result = "0";

  void addToEquation(String text) {
    if (text == "C") {
      //verifier si la chaine a au moins 1 caracter
      if (equation.length == 1) {
        setState(() {
          equation = equation.substring(0, equation.length - 1);
        });
      }
      return;
    }

    if (text == "AC") {
      setState(() {
        equation = "0";
        result = "0";
      });
      return;
    }

    if (text == "=") {
      //detecte if equation contain "/0"
      if (equation.contains("/0")) {
        setState(() {
          result = "can't divide by 0";
        });
        return;
      }

      Expression expression = Parser().parse(equation);
      ContextModel contextModel = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        result = eval.toString();
      });
      return;
    }
    if (equation == "0") {
      setState(() {
        equation = text;
      });
    } else {
      setState(() {
        equation = equation + text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = (orientation == Orientation.portrait) ? 5 : 10;

    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: const Color.fromARGB(255, 177, 177, 177),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[Text(equation), Text(result)],
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
    );
  }

  Widget buildButton(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) {
              return const EdgeInsets.all(16.0);
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return const Color.fromARGB(255, 255, 255, 255);
            }),
          ),
          onPressed: () {
            addToEquation(text);
          },
          child: Text(
            text,
            style:
                const TextStyle(fontSize: 15, overflow: TextOverflow.visible),
          )),
    );
  }
}
