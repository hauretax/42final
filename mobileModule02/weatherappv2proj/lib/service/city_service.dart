import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherappv2proj/model/city_model.dart';

class CityService {
  Future<List<City>> fetchCities(String query) async {
    final encodedCityName = Uri.encodeComponent(query);
    final apiUrl =
        'https://geocoding-api.open-meteo.com/v1/search?name=$encodedCityName&count=5&language=en&format=json';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['results'];
      List<City> cities = results.map((item) => City.fromJson(item)).toList();
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
