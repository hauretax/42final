import 'package:weatherappv2proj/utils/printInColor.dart';

class Weather {
  final double temperature;
  final double windspeed;
  final String weatherDescription;

  Weather({
    required this.temperature,
    required this.windspeed,
    required this.weatherDescription,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    printRed(json.toString());
    return Weather(
      temperature: json['current_weather']['temperature'] as double,
      windspeed: json['current_weather']['windspeed'] as double,
      weatherDescription: json['current_weather']['weathercode'].toString(),
    );
  }
}
