import 'package:flutter/material.dart';
import 'package:weather_final_proj/model/city_model.dart';
import 'package:weather_final_proj/model/weather_model.dart';

class TodayTab extends StatefulWidget {
  final HourlyWeather? hourlyWeather;
  final City? city;
  final String error;
  const TodayTab(
      {super.key, this.hourlyWeather, this.city, required this.error});

  @override
  State<TodayTab> createState() => _TodayTab();
}

class _TodayTab extends State<TodayTab> {
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
    if (widget.city != null && widget.hourlyWeather != null) {
      return Column(children: <Widget>[
        Flexible(
            fit: FlexFit.tight,
            child: Column(children: <Widget>[
              Text(
                widget.city!.name,
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                "${widget.city!.country} - ${widget.city!.region}",
                style: const TextStyle(
                    fontSize: 10, color: Color.fromARGB(255, 71, 71, 71)),
              ),
            ])),
        Flexible(
            child: ListView.builder(
          itemCount: widget.hourlyWeather!.weather.length,
          itemBuilder: (context, index) {
            var weather = widget.hourlyWeather!.weather[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        weather['time'],
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        "${weather['temperature_2m']} °C",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${weather['weather_code']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Wind Speed: ${weather['wind_speed_10m']} km/h",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ))
      ]);
    }
    return const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Today")]),
    );
  }
}
