class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final int rainChance;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.rainChance,
  });

  String get desc => describeWeatherCode(weatherCode);
}

class Forecast {
  final double currentTemp;
  final int currentWeatherCode;
  final List<DailyForecast> daily;

  const Forecast({
    required this.currentTemp,
    required this.currentWeatherCode,
    required this.daily,
  });

  // Maps the Open-Meteo JSON into Dart objects.
  factory Forecast.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final dates = daily['time'] as List<dynamic>;
    final codes = daily['weather_code'] as List<dynamic>;
    final maxes = daily['temperature_2m_max'] as List<dynamic>;
    final mins = daily['temperature_2m_min'] as List<dynamic>;
    final rain = daily['precipitation_probability_max'] as List<dynamic>;

    final days = <DailyForecast>[
      for (var i = 0; i < dates.length; i++)
        DailyForecast(
          date: DateTime.parse(dates[i] as String),
          weatherCode: (codes[i] as num?)?.toInt() ?? 0,
          tempMax: (maxes[i] as num).toDouble(),
          tempMin: (mins[i] as num).toDouble(),
          // The API can return null for days it has no rain data for.
          rainChance: (rain[i] as num?)?.round() ?? 0,
        ),
    ];

    if (days.isEmpty) throw const FormatException('No daily forecast data');

    return Forecast(
      currentTemp: (current['temperature_2m'] as num).toDouble(),
      currentWeatherCode: (current['weather_code'] as num).toInt(),
      daily: days,
    );
  }

  int get todayRainChance => daily.first.rainChance;

  // Suggestion shown on the Home weather card.
  String get tip {
    if (todayRainChance >= 60) {
      return 'Bring an umbrella';
    }
    if (todayRainChance >= 30) {
      return 'Rain is possible. Pack an umbrella just in case';
    }
    if (currentTemp >= 33) return 'Very hot. Bring water';
    {
      return 'Good weather for getting around';
    }
  }
}

// Converts Open-Meteo's WMO weather codes into readable text.
String describeWeatherCode(int code) {
  if (code == 0) return 'Clear sky';
  if (code <= 3) return 'Partly cloudy';
  if (code == 45 || code == 48) return 'Fog';
  if (code >= 51 && code <= 57) return 'Drizzle';
  if (code >= 61 && code <= 67) return 'Rain';
  if (code >= 80 && code <= 82) return 'Rain showers';
  if (code >= 95) return 'Thunderstorm';
  return 'Unknown';
}
