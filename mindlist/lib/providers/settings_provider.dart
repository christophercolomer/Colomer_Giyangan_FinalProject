import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location.dart';

class SettingsProvider extends ChangeNotifier {
  static const _themeKey = 'theme_mode';
  static const _locationKey = 'location_name';

  final SharedPreferences _prefs;
  ThemeMode _themeMode;
  Location _location;

  SettingsProvider._(this._prefs, this._themeMode, this._location);

  // Reads saved settings before the app starts, so the first frame
  // already uses the right theme and location.
  static Future<SettingsProvider> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);
    final locationName = prefs.getString(_locationKey);

    return SettingsProvider._(
      prefs,
      ThemeMode.values.firstWhere(
        (m) => m.name == themeName,
        orElse: () => ThemeMode.light,
      ),
      philippineCities.firstWhere(
        (c) => c.name == locationName,
        orElse: () => philippineCities.first,
      ),
    );
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  Location get location => _location;

  void setDark(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString(_themeKey, _themeMode.name);
    notifyListeners();
  }

  void setLocation(Location location) {
    if (location == _location) return;
    _location = location;
    _prefs.setString(_locationKey, location.name);
    notifyListeners();
  }
}