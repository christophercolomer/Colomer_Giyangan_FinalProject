import 'package:flutter/material.dart';

import '../app_routes.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(child: Text('Home')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.taskAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}
