import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get pendingTasks => _tasks.where((t) => !t.isDone).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isDone).toList();

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks
        .where(
          (t) =>
              !t.isDone &&
              t.dueDate.year == now.year &&
              t.dueDate.month == now.month &&
              t.dueDate.day == now.day,
        )
        .toList();
  }

  Task? findById(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    return i == -1 ? null : _tasks[i];
  }

  void addTask({
    required String title,
    required String className,
    required DateTime dueDate,
    Priority priority = Priority.medium,
  }) {
    _tasks.add(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        className: className,
        dueDate: dueDate,
        priority: priority,
      ),
    );
    notifyListeners();
  }

  void updateTask(
    String id, {
    String? title,
    String? className,
    DateTime? dueDate,
    Priority? priority,
  }) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _tasks[i] = _tasks[i].copyWith(
      title: title,
      className: className,
      dueDate: dueDate,
      priority: priority,
    );
    notifyListeners();
  }

  void toggleDone(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _tasks[i] = _tasks[i].copyWith(isDone: !_tasks[i].isDone);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
