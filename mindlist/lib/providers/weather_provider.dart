import 'package:flutter/foundation.dart';

import '../models/location.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

enum WeatherStatus { loading, success, error, offline }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service;

  WeatherProvider({WeatherService? service})
      : _service = service ?? WeatherService();

  Location? _location;
  WeatherStatus _status = WeatherStatus.loading;
  Forecast? _forecast;
  String? _errorMessage;
  int _requestId = 0;

  String get locationName => _location?.name ?? '';
  WeatherStatus get status => _status;
  Forecast? get forecast => _forecast;
  String? get errorMessage => _errorMessage;

  // True when a failed refresh left us showing older data.
  bool get isShowingStaleData =>
      _forecast != null &&
      (_status == WeatherStatus.error || _status == WeatherStatus.offline);

  // Called whenever Settings changes. Does nothing if the city is the same.
  void updateLocation(Location location) {
    if (location == _location) return;
    _location = location;
    // Drop the old city's data so it is never shown under the new name.
    _forecast = null;
    _status = WeatherStatus.loading;
    // Wait until the current build finishes before notifying listeners.
    Future.microtask(loadForecast);
  }

  Future<void> loadForecast() async {
    final location = _location;
    if (location == null) return;

    // If the user switches city mid-request, the older response is ignored.
    final requestId = ++_requestId;
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.fetchForecast(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      if (requestId != _requestId) return;
      _forecast = result;
      _status = WeatherStatus.success;
    } on OfflineException catch (e) {
      if (requestId != _requestId) return;
      _status = WeatherStatus.offline;
      _errorMessage = e.message;
    } on WeatherException catch (e) {
      if (requestId != _requestId) return;
      _status = WeatherStatus.error;
      _errorMessage = e.message;
    } catch (_) {
      if (requestId != _requestId) return;
      _status = WeatherStatus.error;
      _errorMessage = 'Something went wrong. Please try again.';
    }
    notifyListeners();
  }
}