import 'package:geocoding/geocoding.dart';

class City {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  City(
      {required this.name,
      required this.region,
      required this.country,
      required this.latitude,
      required this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      region: json['admin1'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  factory City.fromPlacemarks(
      Placemark placemark, double latitude, double longitude) {
    return City(
      name: placemark.name!,
      region: placemark.administrativeArea!,
      country: placemark.country!,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
