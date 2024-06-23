
String getWeatherEmoji(int code) {
  const emojis = {
    0: '☀️',
    1: '🌤️',
    2: '⛅',
    3: '☁️',
    45: '🌫️',
    48: '🌫️❄️',
    51: '🌧️',
    53: '🌧️☔',
    55: '🌧️☔⚡',
    56: '🥶🌧️',
    57: '🥶🌧️☔',
    61: '🌧️',
    63: '🌧️☔',
    65: '🌧️☔⛈️',
    66: '🥶🌧️',
    67: '🥶🌧️☔',
    71: '🌨️',
    73: '🌨️❄️',
    75: '🌨️❄️⛈️',
    77: '🌨️',
    80: '🌧️',
    81: '🌧️☔',
    82: '🌧️☔⛈️',
    85: '🌨️',
    86: '🌨️❄️',
    95: '⛈️',
    96: '⛈️☔',
    99: '⛈️☔⚡',
  };

  return emojis[code] ?? '❓';
}

String getWeatherDescription(int weatherCode) {
  const weatherDescriptions = {
    0: 'Clear weather',
    1: 'Mostly clear',
    2: 'Partly cloudy',
    3: 'Cloudy',
    45: 'Fog',
    48: 'Freezing fog',
    51: 'Light drizzle',
    53: 'Moderate drizzle',
    55: 'Dense drizzle',
    56: 'Light freezing drizzle',
    57: 'Dense freezing drizzle',
    61: 'Light rain',
    63: 'Moderate rain',
    65: 'Heavy rain',
    66: 'Light freezing rain',
    67: 'Heavy freezing rain',
    71: 'Light snow',
    73: 'Moderate snow',
    75: 'Heavy snow',
    77: 'Snow grains',
    80: 'Light rain showers',
    81: 'Moderate rain showers',
    82: 'Violent rain showers',
    85: 'Light snow showers',
    86: 'Violent snow showers',
    95: 'Thunderstorms',
    96: 'Thunderstorms with light hail',
    99: 'Thunderstorms with heavy hail',
  };

  return weatherDescriptions[weatherCode] ?? 'Unknown weather code';
}
