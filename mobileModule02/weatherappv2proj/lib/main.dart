import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherappv2proj/currently.dart';

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
  bool _locationPermissionDenied = false;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }

    // Check and request location permission using permission_handler
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() {
          _locationPermissionDenied = true;
        });
        return Future.error('Location permission denied');
      }
    }

    // Check if the permission is denied forever
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setText(
          'Location permissions are permanently denied, please open settings to change it');
      setState(() {
        _locationPermissionDenied = true;
      });
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }

    // Continue accessing the position of the device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

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
            onPressed: () async {
              try {
                Position position = await _getGeoLocationPosition();
                setText(position.latitude.toString() +
                    ',' +
                    position.longitude.toString());
              } catch (e) {
                setText(e.toString());
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CurrentlyTab(
            title: 'Currentlyyyyyy',
            location: _actualText,
            permited: !_locationPermissionDenied,
          ),
          CurrentlyTab(
            title: 'Today',
            location: _actualText,
            permited: !_locationPermissionDenied,
          ),
          CurrentlyTab(
            title: 'Weekly',
            location: _actualText,
            permited: !_locationPermissionDenied,
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
      ),
    );
  }
}
