import 'package:flutter/material.dart';

class CurrentlyTab extends StatefulWidget {
  final String title;
  final String location;
  const CurrentlyTab({super.key, required this.title, required this.location});

  @override
  State<CurrentlyTab> createState() => _CurrentlyTab();
}

class _CurrentlyTab extends State<CurrentlyTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(widget.title), Text(widget.location)]));
  }
}
