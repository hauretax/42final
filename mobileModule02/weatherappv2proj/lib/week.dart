import 'package:flutter/material.dart';
import 'package:weatherappv2proj/model/city_model.dart';
import 'package:weatherappv2proj/model/weather_model.dart';

class WeekTab extends StatefulWidget {
  final WeekWeather? weekWeather;
  final City? city;
  final String error;
  const WeekTab({super.key, this.weekWeather, this.city, required this.error});

  @override
  State<WeekTab> createState() => _WeekTab();
}

class _WeekTab extends State<WeekTab> {
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
    if (widget.city != null && widget.weekWeather != null) {
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
          itemCount: widget.weekWeather!.weather.length,
          itemBuilder: (context, index) {
            var weather = widget.weekWeather!.weather[index];
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
                        "${weather['temperature_2m_min']} - ${weather['temperature_2m_max']} °C",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        " ${weather['weather_code']}",
                        style: const TextStyle(fontSize: 20),
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
