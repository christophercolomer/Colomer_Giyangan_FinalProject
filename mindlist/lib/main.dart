import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';

import 'app_routes.dart';
import 'screens/bottom_nav.dart';
import 'screens/task_detail_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MindList(),
    ),
  );
}

class MindList extends StatelessWidget {
  const MindList({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindList',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
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
