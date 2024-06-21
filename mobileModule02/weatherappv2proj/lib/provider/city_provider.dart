import 'package:flutter/material.dart';
import 'package:weatherappv2proj/model/city_model.dart';
import 'package:weatherappv2proj/service/city_service.dart';


class CityProvider with ChangeNotifier {
  CityService _cityService = CityService();
  List<City> _cities = [];
  bool _loading = false;

  List<City> get cities => _cities;
  bool get loading => _loading;

  Future<void> searchCities(String query) async {
    _loading = true;
    notifyListeners();

    try {
      _cities = await _cityService.fetchCities(query);
    } catch (e) {
      _cities = [];
    }

    _loading = false;
    notifyListeners();
  }
}
