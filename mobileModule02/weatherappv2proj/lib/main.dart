import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherappv2proj/curent.dart';
import 'package:weatherappv2proj/currently.dart';
import 'package:weatherappv2proj/model/city_model.dart';
import 'package:weatherappv2proj/model/weather_model.dart';
import 'package:weatherappv2proj/service/city_service.dart';
import 'package:weatherappv2proj/service/weather_service.dart';
import 'package:weatherappv2proj/utils/printInColor.dart';

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

  final TextEditingController _controller = TextEditingController();
  final CityService _cityService = CityService();
  final WeatherService _weatherService = WeatherService();
  List<City> _cities = [];
  Weather? _weather = null;
  City? _city = null;
  FocusNode _searchFocusNode = FocusNode();

  void _searchCities(String query) async {
    try {
      final cities = await _cityService.fetchCities(query);
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      setState(() {
        _cities = [];
      });
    }
  }

  void setCity(City city) {
    setState(() {
      _city = city;
    });
  }

  void _searchWeather(double latitude, double longitude) async {
    try {
      final weather = await _weatherService.fetchWeather(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      printBrightRed("Error: $e");
      _weather = null;
    }
  }

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
    _tabController.dispose(); // Dispose of TabController
    _controller.dispose(); // Dispose of TextEditingController
    _searchFocusNode.dispose(); // Dispose of FocusNode
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
            controller: _controller,
            focusNode: _searchFocusNode,
            onSubmitted: (value) async {
              final cities = await _cityService.fetchCities(value);
              setCity(cities[0]);
              _searchWeather(cities[0].latitude, cities[0].longitude);
              _searchFocusNode.unfocus();
              setState(() {
                _cities = [];
              });
            },
            onChanged: (value) {
              setText(value);
              if (value.isNotEmpty) {
                _searchCities(value);
              } else {
                setState(() {
                  _cities = [];
                });
              }
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
                setText('${position.latitude},${position.longitude}');
              } catch (e) {
                setText(e.toString());
              }
            },
          ),
        ],
      ),
      body: Column(children: [
        if (_cities.isNotEmpty) _buildCitiesList(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              CurrentTab(permited: true, weather: _weather, city: _city),
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
        )
      ]),
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

  Widget _buildCitiesList() {
    return Expanded(
        child: ListView.builder(
      itemCount: _cities.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_cities[index].name),
          subtitle:
              Text('${_cities[index].country} - ${_cities[index].region}'),
          onTap: () {
            _searchWeather(_cities[index].latitude, _cities[index].longitude);
            setCity(_cities[index]);
            _searchFocusNode.unfocus();
            setState(() {
              _cities = [];
            });
          },
        );
      },
    ));
  }
}
