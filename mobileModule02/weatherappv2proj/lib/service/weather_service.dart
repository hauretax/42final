import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherappv2proj/model/weather_model.dart';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(
      double latitude, double longitude) async {
    DateTime now = DateTime.now();

    final DateTime firstDayWeek = now.subtract(Duration(days: now.weekday - 1));
    final DateTime lastDayWeek = firstDayWeek.add(const Duration(days: 6));
    final String formattedFirstDayWeek =
        firstDayWeek.toIso8601String().substring(0, 10);
    final String formattedLastDayWeek =
        lastDayWeek.toIso8601String().substring(0, 10);

    final apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true';

    const currentRequest = '&current_weather=true';
    const todayRequest =
        '&hourly=temperature_2m,weather_code,wind_speed_10m&forecast_days=1';

    final weekRequest =
        '&daily=weather_code,temperature_2m_max,temperature_2m_min&start_date=$formattedFirstDayWeek&end_date=$formattedLastDayWeek';

    List<http.Response> responses = await Future.wait([
      http.get(Uri.parse(apiUrl + currentRequest)),
      http.get(Uri.parse(apiUrl + todayRequest)),
      http.get(Uri.parse(apiUrl + weekRequest))
    ]);

    final currentResponse = responses[0];
    final todayResponse = responses[1];
    final weekResponse = responses[2];

    Weather weather;
    HourlyWeather hourlyWeather;
    WeekWeather weekWeather;
    if (currentResponse.statusCode == 200) {
      weather = Weather.fromJson(json.decode(currentResponse.body));
    } else {
      throw Exception('Failed to load weather data');
    }
    if (todayResponse.statusCode == 200) {
      hourlyWeather = HourlyWeather.fromJson(json.decode(todayResponse.body));
    } else {
      throw Exception('Failed to load weather data');
    }
    if (weekResponse.statusCode == 200) {
      weekWeather = WeekWeather.fromJson(json.decode(weekResponse.body));
    } else {
      throw Exception('Failed to load weather data');
    }
    return {
      'weather': weather,
      'hourlyWeather': hourlyWeather,
      'weekWeather': weekWeather
    };
  }
}
