enum Priority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String className;
  final DateTime dueDate;
  final Priority priority;
  final bool isDone;

  const Task({
    required this.id,
    required this.title,
    required this.className,
    required this.dueDate,
    this.priority = Priority.medium,
    this.isDone = false,
  });

  Task copyWith({
    String? title,
    String? className,
    DateTime? dueDate,
    Priority? priority,
    bool? isDone,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      className: className ?? this.className,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
    );
  }
}
