import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  // Read-only views so the UI can't modify the list directly
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  List<Task> get pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();

  Task? getById(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    return index == -1 ? null : _tasks[index];
  }

  // CREATE
  void addTask({
    required String title,
    String description = '',
    DateTime? dueDate,
  }) {
    _tasks.add(Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dueDate: dueDate,
    ));
    notifyListeners();
  }

  // UPDATE
  void editTask(
    String id, {
    String? title,
    String? description,
    DateTime? dueDate,
  }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(
      title: title,
      description: description,
      dueDate: dueDate,
    );
    notifyListeners();
  }

  // COMPLETE (toggles, so it also works as "undo")
  void toggleComplete(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _tasks[index] =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    notifyListeners();
  }

  // DELETE
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}