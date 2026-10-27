import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}

class OfflineException extends WeatherException {
  const OfflineException() : super('No internet connection');
}

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<Forecast> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'temperature_2m,weather_code',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw WeatherException(
          'The weather service had a problem (code ${response.statusCode})',
        );
      }
      return Forecast.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on SocketException {
      throw const OfflineException();
    } on http.ClientException {
      throw const OfflineException();
    } on TimeoutException {
      throw const WeatherException('The request timed out. Please try again.');
    } on FormatException {
      throw const WeatherException(
        'Received unexpected data from the weather service',
      );
    } on TypeError {
      throw const WeatherException(
        'Received unexpected data from the weather service',
      );
    }
  }
}
