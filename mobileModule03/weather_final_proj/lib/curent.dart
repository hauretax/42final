import 'package:flutter/material.dart';
import 'package:weather_final_proj/model/city_model.dart';
import 'package:weather_final_proj/model/weather_model.dart';

class CurrentTab extends StatefulWidget {
  final Weather? weather;
  final City? city;
  final String error;
  const CurrentTab({super.key, this.weather, this.city, required this.error});

  @override
  State<CurrentTab> createState() => _CurrentTab();
}

class _CurrentTab extends State<CurrentTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.error != '') {
      return Container(
        color: Colors.red[100],
        child: Center(
          child: Text(
            widget.error,
            style: TextStyle(color: Colors.red[900], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (widget.city != null && widget.weather != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Column(children: <Widget>[
            Text(
              widget.city!.name,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${widget.city!.country} - ${widget.city!.region}",
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 71, 71, 71)),
            ),
          ]),
          Column(children: <Widget>[
            Text(
              "${widget.weather!.temperature} °C",
              style: const TextStyle(fontSize: 45),
            ),
            Text(
              " ${widget.weather!.weatherEmoji}",
              style: const TextStyle(fontSize: 40, color: Color(0xFF000000)),
            ),
            Text(
              "${widget.weather!.weatherDescription} - ${widget.weather!.windspeed} km/h",
              style: const TextStyle(fontSize: 20, color: Color(0xFF000000)),
            ),
          ]),
        ]),
      );
    }
    return const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("curent")]),
    );
  }
}
