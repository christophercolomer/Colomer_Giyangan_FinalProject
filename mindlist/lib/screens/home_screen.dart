import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../providers/task_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_card.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayTasks = context.watch<TaskProvider>().todayTasks;

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
          // TODO: replace with real data from WeatherProvider
          const WeatherCard(
            temperature: 28,
            rainChance: 70,
            tip: 'Bring an umbrella',
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
