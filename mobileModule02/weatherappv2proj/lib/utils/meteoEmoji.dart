String getWeatherEmoji(String weatherCode) {
  switch (weatherCode) {
    case '0': return '☀️';
    case '1': return '🌤️';
    case '2': return '⛅';
    case '3': return '☁️';
    case '45': return '🌫️';
    case '48': return '🌫️❄️';
    case '51': return '🌧️';
    case '53': return '🌧️☔';
    case '55': return '🌧️☔⚡';
    case '56': return '🥶🌧️';
    case '57': return '🥶🌧️☔';
    case '61': return '🌧️';
    case '63': return '🌧️☔';
    case '65': return '🌧️☔⛈️';
    case '66': return '🥶🌧️';
    case '67': return '🥶🌧️☔';
    case '71': return '🌨️';
    case '73': return '🌨️❄️';
    case '75': return '🌨️❄️⛈️';
    case '77': return '🌨️';
    case '80': return '🌧️';
    case '81': return '🌧️☔';
    case '82': return '🌧️☔⛈️';
    case '85': return '🌨️';
    case '86': return '🌨️❄️';
    case '95': return '⛈️';
    case '96': return '⛈️☔';
    case '99': return '⛈️☔⚡';
    default: return '❓';
  }
}
