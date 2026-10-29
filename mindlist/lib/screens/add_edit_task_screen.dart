import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _classController = TextEditingController();
  DateTime? _dueDate;
  Priority _priority = Priority.medium;
  String? _editingId;
  bool _loaded = false;
  bool _dateError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String) {
      final task = context.read<TaskProvider>().findById(arg);
      if (task != null) {
        _editingId = task.id;
        _titleController.text = task.title;
        _classController.text = task.className;
        _dueDate = task.dueDate;
        _priority = task.priority;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _classController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateError = false;
      });
    }
  }

  void _save() {
    final formOk = _formKey.currentState!.validate();
    setState(() => _dateError = _dueDate == null);
    if (!formOk || _dueDate == null) return;

    final provider = context.read<TaskProvider>();
    final title = _titleController.text.trim();
    final className = _classController.text.trim();

    if (_editingId == null) {
      provider.addTask(
        title: title,
        className: className,
        dueDate: _dueDate!,
        priority: _priority,
      );
    } else {
      provider.updateTask(
        _editingId!,
        title: title,
        className: className,
        dueDate: _dueDate,
        priority: _priority,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit task' : 'Add task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.isEmpty) return 'Enter a title';
                if (text.length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _classController,
              decoration: const InputDecoration(
                labelText: 'Class (e.g., SE2142)',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a class' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Due date',
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                  errorText: _dateError ? 'Pick a due date' : null,
                ),
                child: Text(
                  _dueDate == null
                      ? 'Select a date'
                      : DateFormat('EEE, MMM d, y').format(_dueDate!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Priority', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<Priority>(
              segments: const [
                ButtonSegment(value: Priority.low, label: Text('Low')),
                ButtonSegment(value: Priority.medium, label: Text('Medium')),
                ButtonSegment(value: Priority.high, label: Text('High')),
              ],
              selected: {_priority},
              onSelectionChanged: (s) => setState(() => _priority = s.first),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: Text(isEditing ? 'Save changes' : 'Save task'),
            ),
          ],
        ),
      ),
    );
  }
}
