import 'package:flutter/material.dart';
import 'package:weather_app_proj/currently.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _actualText = "";

  void setText(text) {
    setState(() {
      _actualText = text;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.pink,
            title: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                onChanged: (value) {
                  print('Input: $value');
                  setText(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white24,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.navigation_rounded),
                tooltip: 'Geolocation',
                onPressed: () {
                  setText('Geolocation');
                },
              ),
            ]),
        body: TabBarView(
          controller: _tabController,
          children: [
            CurrentlyTab(
              title: 'CUrrently',
              location: _actualText,
            ),
            CurrentlyTab(
              title: 'Today',
              location: _actualText,
            ),
            CurrentlyTab(
              title: 'Weekly',
              location: _actualText,
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.watch), text: 'Currently'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Today'),
              Tab(icon: Icon(Icons.next_week), text: 'Weekly'),
            ],
          ),
        ));
  }
}
