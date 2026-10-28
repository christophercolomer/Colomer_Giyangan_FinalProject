import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'providers/settings_provider.dart';
import 'providers/task_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/add_edit_task_screen.dart';
import 'screens/bottom_nav.dart';
import 'screens/settings_screen.dart';
import 'screens/task_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await SettingsProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        // Gives WeatherProvider the chosen location, and again on every change.
        ChangeNotifierProxyProvider<SettingsProvider, WeatherProvider>(
          create: (_) => WeatherProvider(),
          update: (_, settings, weather) =>
              weather!..updateLocation(settings.location),
        ),
      ],
      child: const MindList(),
    ),
  );
}

class MindList extends StatelessWidget {
  const MindList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsProvider>().themeMode;
    const seed = Colors.deepPurple;

    return MaterialApp(
      title: 'MindList',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: seed)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const BottomNav(initialIndex: 0),
        AppRoutes.tasks: (_) => const BottomNav(initialIndex: 1),
        AppRoutes.forecast: (_) => const BottomNav(initialIndex: 2),
        AppRoutes.taskDetail: (_) => const TaskDetailScreen(),
        AppRoutes.taskAdd: (_) => const AddEditTaskScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
