import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>();
    final isLoading = weather.status == WeatherStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading
                ? null
                : () => context.read<WeatherProvider>().loadForecast(),
          ),
        ],
      ),
      body: _body(context, weather),
    );
  }

  Widget _body(BuildContext context, WeatherProvider weather) {
    final forecast = weather.forecast;

    // Nothing to show yet: first load, or a failure with no older data.
    if (forecast == null) {
      if (weather.status == WeatherStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return _ErrorView(status: weather.status, message: weather.errorMessage);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (weather.status == WeatherStatus.loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          ),
        if (weather.isShowingStaleData)
          _StaleBanner(
            status: weather.status,
            message: weather.errorMessage ?? 'Could not refresh',
          ),
        Text(
          weather.locationName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        WeatherCard(
          temperature: forecast.currentTemp.round(),
          rainChance: forecast.todayRainChance,
          tip: forecast.tip,
        ),
        const SizedBox(height: 16),
        Text('Next 7 days', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final day in forecast.daily) _DayTile(day: day),
      ],
    );
  }
}

// Full-screen message with a retry button (no data to fall back on).
class _ErrorView extends StatelessWidget {
  final WeatherStatus status;
  final String? message;

  const _ErrorView({required this.status, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status == WeatherStatus.offline
                  ? Icons.wifi_off
                  : Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.read<WeatherProvider>().loadForecast(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

// Shown above older data when a refresh fails.
class _StaleBanner extends StatelessWidget {
  final WeatherStatus status;
  final String message;

  const _StaleBanner({required this.status, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.errorContainer,
      child: ListTile(
        leading: Icon(
          status == WeatherStatus.offline ? Icons.wifi_off : Icons.error_outline,
          color: scheme.onErrorContainer,
        ),
        title: Text(message, style: TextStyle(color: scheme.onErrorContainer)),
        subtitle: Text(
          'Showing the last loaded forecast',
          style: TextStyle(color: scheme.onErrorContainer),
        ),
        trailing: TextButton(
          onPressed: () => context.read<WeatherProvider>().loadForecast(),
          child: const Text('Retry'),
        ),
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final DailyForecast day;

  const _DayTile({required this.day});

  String _dayLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(day.date.year, day.date.month, day.date.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return DateFormat('EEE, MMM d').format(day.date);
  }

  IconData _icon() {
    final code = day.weatherCode;
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.wb_cloudy;
    if (code >= 51 && code <= 57) return Icons.grain;
    if (code >= 61 && code <= 67) return Icons.umbrella;
    if (code >= 80 && code <= 82) return Icons.umbrella;
    if (code >= 95) return Icons.flash_on;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_icon(), size: 32),
        title: Text(_dayLabel()),
        subtitle: Text(day.description),
        trailing: Text(
          '${day.tempMax.round()}° / ${day.tempMin.round()}°\n${day.rainChance}% rain',
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}