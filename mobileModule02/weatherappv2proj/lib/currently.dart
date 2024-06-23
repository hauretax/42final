import 'package:flutter/material.dart';

class CurrentlyTab extends StatefulWidget {
  final String title;
  final String location;
  final bool permited;
  const CurrentlyTab(
      {super.key,
      required this.title,
      required this.location,
      required this.permited});

  @override
  State<CurrentlyTab> createState() => _CurrentlyTab();
}

class _CurrentlyTab extends State<CurrentlyTab> {
  @override
  Widget build(BuildContext context) {
    return widget.permited
        ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text(widget.title), Text(widget.location)]))
        : Container(
            color: Colors.red[100],
            child: Center(
              child: Text(
                'Location permissions are permanently denied, please open settings to change it',
                style: TextStyle(color: Colors.red[900], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
