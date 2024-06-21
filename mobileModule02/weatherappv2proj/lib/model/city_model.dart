class City {
  final String name;
  final double latitude;
  final double longitude;

  City({required this.name, required this.latitude, required this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}