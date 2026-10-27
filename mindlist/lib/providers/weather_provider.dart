import 'package:flutter/foundation.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

enum WeatherStatus { loading, success, error, offline }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service;

  WeatherProvider({WeatherService? service})
    : _service = service ?? WeatherService();

  final double _latitude = 10.720321;
  final double _longitude = 122.562019;
  final String locationName = 'Iloilo City';

  WeatherStatus _status = WeatherStatus.loading;
  Forecast? _forecast;
  String? _errorMessage;

  WeatherStatus get status => _status;
  Forecast? get forecast => _forecast;
  String? get errorMessage => _errorMessage;

  bool get isShowingOldData =>
      _forecast != null &&
      (_status == WeatherStatus.error || _status == WeatherStatus.offline);

  Future<void> loadForecast() async {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _forecast = await _service.fetchForecast(
        latitude: _latitude,
        longitude: _longitude,
      );
      _status = WeatherStatus.success;
    } on OfflineException catch (e) {
      _status = WeatherStatus.offline;
      _errorMessage = e.message;
    } on WeatherException catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.message;
    } catch (_) {
      _status = WeatherStatus.error;
      _errorMessage = 'Something went wrong. Please try again.';
    }
    notifyListeners();
  }
}
