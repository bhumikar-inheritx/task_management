import 'package:flutter/foundation.dart';

enum TaskStatus { pending, inProgress, completed }
enum TaskPriority { low, medium, high }

class Task {
  late String title;
  late String description;
  late TaskStatus status;
  late bool isDone;
  late TaskPriority priority;

  Task({
    required this.title,
    required this.description,
    this.status = TaskStatus.pending,
    this.isDone = false,
    this.priority = TaskPriority.medium,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'status': status.name,
    'priority': priority.name,
  };
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      status: TaskStatus.values.firstWhere((e) => e.name == map['status']),
      priority: TaskPriority.values.firstWhere((e) => e.name == map['priority']),
    );
  }
}
