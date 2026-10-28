import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_card.dart';

enum StatusFilter { all, pending, done }

enum DueFilter { any, today, next7Days, overdue }

const _statusLabels = {
  StatusFilter.all: 'All',
  StatusFilter.pending: 'Pending',
  StatusFilter.done: 'Done',
};

const _dueLabels = {
  DueFilter.any: 'Any date',
  DueFilter.today: 'Today',
  DueFilter.next7Days: 'Next 7 days',
  DueFilter.overdue: 'Overdue',
};

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  StatusFilter _status = StatusFilter.all;
  DueFilter _due = DueFilter.any;

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _matchesDue(Task t) {
    final today = _dayOnly(DateTime.now());
    final due = _dayOnly(t.dueDate);
    return switch (_due) {
      DueFilter.any => true,
      DueFilter.today => due == today,
      DueFilter.next7Days =>
        !due.isBefore(today) &&
            due.isBefore(today.add(const Duration(days: 7))),
      DueFilter.overdue => due.isBefore(today) && !t.isDone,
    };
  }

  // Applies both filters, then sorts by earliest due date.
  List<Task> _apply(List<Task> all) {
    final result = all.where((t) {
      final statusOk = switch (_status) {
        StatusFilter.all => true,
        StatusFilter.pending => !t.isDone,
        StatusFilter.done => t.isDone,
      };
      return statusOk && _matchesDue(t);
    }).toList();
    result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return result;
  }

  Widget _chipRow<T>({
    required List<T> values,
    required T selected,
    required String Function(T) label,
    required ValueChanged<T> onSelected,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final v in values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label(v)),
                selected: v == selected,
                onSelected: (_) => onSelected(v),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = context.watch<TaskProvider>().tasks;
    final tasks = _apply(all);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _chipRow<StatusFilter>(
            values: StatusFilter.values,
            selected: _status,
            label: (v) => _statusLabels[v]!,
            onSelected: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: 4),
          _chipRow<DueFilter>(
            values: DueFilter.values,
            selected: _due,
            label: (v) => _dueLabels[v]!,
            onSelected: (v) => setState(() => _due = v),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? EmptyState(
                    icon: Icons.inbox_outlined,
                    message: all.isEmpty
                        ? 'No tasks yet. Tap + to add one.'
                        : 'No tasks match these filters',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    children: [for (final t in tasks) TaskCard(task: t)],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.taskAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}
