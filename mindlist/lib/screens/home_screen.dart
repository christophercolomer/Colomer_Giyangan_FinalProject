import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../providers/task_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_card.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayTasks = context.watch<TaskProvider>().todayTasks;
    final weather = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (weather.forecast case final f?)
            WeatherCard(
              temperature: f.currentTemp.round(),
              rainChance: f.todayRainChance,
              tip: f.tip,
            )
          else
            _WeatherPlaceholder(
              status: weather.status,
              message: weather.errorMessage,
            ),
          const SizedBox(height: 24),
          Text("Today's tasks", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (todayTasks.isEmpty)
            const EmptyState(
              icon: Icons.check_circle_outline,
              message: 'Nothing due today',
            )
          else
            for (final task in todayTasks) TaskCard(task: task),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.taskAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Shown on Home until the forecast has loaded, or if it failed.
class _WeatherPlaceholder extends StatelessWidget {
  final WeatherStatus status;
  final String? message;

  const _WeatherPlaceholder({required this.status, this.message});

  @override
  Widget build(BuildContext context) {
    final loading = status == WeatherStatus.loading;

    return Card(
      child: ListTile(
        leading: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                status == WeatherStatus.offline
                    ? Icons.wifi_off
                    : Icons.error_outline,
              ),
        title: Text(
          loading ? 'Loading weather...' : (message ?? 'Weather unavailable'),
        ),
        trailing: loading
            ? null
            : IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<WeatherProvider>().loadForecast(),
              ),
      ),
    );
  }
}