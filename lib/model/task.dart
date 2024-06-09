import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a Task object.
class Task {
  /// Unique identifier for the task.
  String id;

  /// Title of the task.
  String title;

  /// Description of the task.
  String description;

  /// Deadline of the task.
  DateTime deadline;

  /// Expected duration to complete the task.
  Duration expectedDuration;

  /// Flag indicating whether the task is complete or not.
  bool isComplete;

  /// Constructor for creating a Task object.
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.expectedDuration,
    this.isComplete = false,
  });

  /// Factory method to create a Task object from a map of data.
  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(),
      expectedDuration: Duration(minutes: data['expectedDuration'] ?? 0),
      isComplete: data['isComplete'] ?? false,
    );
  }

  /// Converts the Task object to a map of data.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'expectedDuration': expectedDuration.inMinutes,
      'isComplete': isComplete,
    };
  }
}
