import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherappv2proj/model/weather_model.dart';
import 'package:weatherappv2proj/utils/printInColor.dart';

class WeatherService {
  Future<Weather> fetchWeather(double latitude, double longitude) async {
    final apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,precipitation&current_weather=true';
    final response = await http.get(Uri.parse(apiUrl));
    printBrightCyan(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      Weather weather = Weather.fromJson(data);
      return weather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
