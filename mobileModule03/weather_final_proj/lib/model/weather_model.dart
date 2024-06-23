import 'package:weather_final_proj/utils/meteoEmoji.dart';

class Weather {
  final double temperature;
  final double windspeed;
  final String weatherDescription;
  final String weatherEmoji;

  Weather({
    required this.temperature,
    required this.windspeed,
    required this.weatherDescription,
    required this.weatherEmoji,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['current_weather']['temperature'] as double,
      windspeed: json['current_weather']['windspeed'] as double,
      weatherDescription:
          getWeatherDescription(json['current_weather']['weathercode']),
      weatherEmoji: getWeatherEmoji(json['current_weather']['weathercode']),
    );
  }
}

class HourlyWeather {
  final List<Map<String, dynamic>> weather;

  HourlyWeather({
    required this.weather,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    var hourlyData = json['hourly'];
    List<Map<String, dynamic>> transformedList = [];
    int length = hourlyData['time']?.length ?? 0;
    for (int i = 0; i < length; i++) {
      final time = DateTime.parse(hourlyData['time'][i]);

      transformedList.add({
        'time':
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        'temperature_2m': hourlyData['temperature_2m'][i],
        'weatherDescription':
            getWeatherDescription(hourlyData['weather_code'][i]),
        'weatherEmoji': getWeatherEmoji(hourlyData['weather_code'][i]),
        'wind_speed_10m': hourlyData['wind_speed_10m'][i],
      });
    }
    return HourlyWeather(weather: transformedList);
  }
}

class WeekWeather {
  final List<Map<String, dynamic>> weather;

  WeekWeather({
    required this.weather,
  });

  factory WeekWeather.fromJson(Map<String, dynamic> json) {
    var weekData = json['daily'];
    List<Map<String, dynamic>> transformedList = [];
    int length = weekData['time']?.length ?? 0;
    for (int i = 0; i < length; i++) {
      transformedList.add({
        'time': weekData['time'][i],
        'temperature_2m_max': weekData['temperature_2m_max'][i],
        'temperature_2m_min': weekData['temperature_2m_min'][i],
        'weatherDescription':
            getWeatherDescription(weekData['weather_code'][i]),
        'weatherEmoji': getWeatherEmoji(weekData['weather_code'][i]),
      });
    }
    return WeekWeather(weather: transformedList);
  }
}
