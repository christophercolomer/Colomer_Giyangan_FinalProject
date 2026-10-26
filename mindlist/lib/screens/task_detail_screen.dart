import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/empty_state.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<TaskProvider>().deleteTask(task.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // The list passes the task's id; look the task up so we always show fresh data.
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final task = context.watch<TaskProvider>().findById(id);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task detail')),
        body: const EmptyState(
          icon: Icons.search_off,
          message: 'This task no longer exists',
        ),
      );
    }

    final p = task.priority.name;
    final priorityLabel = '${p[0].toUpperCase()}${p.substring(1)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.taskAdd,
              arguments: task.id,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, task),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.school_outlined, label: 'Class', value: task.className),
          _InfoRow(
            icon: Icons.event,
            label: 'Due',
            value: DateFormat('EEE, MMM d, y').format(task.dueDate),
          ),
          _InfoRow(icon: Icons.flag_outlined, label: 'Priority', value: priorityLabel),
          _InfoRow(
            icon: Icons.check_circle_outline,
            label: 'Status',
            value: task.isDone ? 'Done' : 'Pending',
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => context.read<TaskProvider>().toggleDone(task.id),
            icon: Icon(task.isDone ? Icons.undo : Icons.check),
            label: Text(task.isDone ? 'Mark as pending' : 'Mark as done'),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}