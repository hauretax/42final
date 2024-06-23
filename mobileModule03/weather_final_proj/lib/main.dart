import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_final_proj/service/city_service.dart';
import 'package:weather_final_proj/curent.dart';
import 'package:weather_final_proj/model/city_model.dart';
import 'package:weather_final_proj/model/weather_model.dart';
import 'package:weather_final_proj/service/weather_service.dart';
import 'package:weather_final_proj/today.dart';
import 'package:weather_final_proj/utils/print_in_color.dart';
import 'package:weather_final_proj/week.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _error = '';

  final TextEditingController _controller = TextEditingController();
  final CityService _cityService = CityService();
  final WeatherService _weatherService = WeatherService();
  final FocusNode _searchFocusNode = FocusNode();
  List<City> _cities = [];
  Weather? _weather;
  HourlyWeather? _hourlyWeather;
  WeekWeather? _weekWeather;
  City? _city;

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
      _setError('');
      setState(() {
        _weather = weather['weather'];
        _hourlyWeather = weather['hourlyWeather'];
        _weekWeather = weather['weekWeather'];
      });
    } catch (e) {
      printRed(e.toString());
      _setError(
          'The service or connection is lost, please check you internet connection or try again later');
      _weather = null;
    }
  }

  void _setError(String error) {
    setState(() {
      _error = error;
    });
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
          _error =
              'Location permissions are permanently denied, please open settings to change it';
        });
        return Future.error('Location permission denied');
      }
    }

    // Check if the permission is denied forever
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _error =
            'Location permissions are permanently denied, please open settings to change it';
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
              try {
                final cities = await _cityService.fetchCities(value);
                _setError('');
                setCity(cities[0]);
                _searchWeather(cities[0].latitude, cities[0].longitude);
                _searchFocusNode.unfocus();
                setState(() {
                  _cities = [];
                });
              } catch (e) {
                _setError(
                    'could not find any results for supplied address or coordinates');
              }
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                _searchCities(value);
              } else {
                setState(() {
                  _cities = [];
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Search location',
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
                _cityService
                    .fetchCitiesByCoordinates(
                        position.latitude, position.longitude)
                    .then((value) {
                  setCity(value);
                });
                _searchWeather(position.latitude, position.longitude);
              } catch (e) {
                _setError(
                    'could not find any results for supplied address or coordinates');
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          if (_cities.isNotEmpty) _buildCitiesList(),
          if (_cities.isEmpty)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  CurrentTab(error: _error, weather: _weather, city: _city),
                  TodayTab(
                    error: _error,
                    hourlyWeather: _hourlyWeather,
                    city: _city,
                  ),
                  WeekTab(
                    error: _error,
                    weekWeather: _weekWeather,
                    city: _city,
                  )
                ],
              ),
            ),
          if (_cities.isEmpty)
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.watch), text: 'Currently'),
                Tab(icon: Icon(Icons.calendar_today), text: 'Today'),
                Tab(icon: Icon(Icons.next_week), text: 'Weekly'),
              ],
            ),
        ]),
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
