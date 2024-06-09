import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task_manager/model/task.dart';
import 'package:flutter/material.dart';
import 'package:firebase_task_manager/services/notification_service.dart';

class TaskService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  Stream<List<Task>> getTasks(String userId) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> addTask(Task task, String userId) async {
    final docRef = await _db.collection('tasks').add({
      'userId': userId,
      ...task.toMap(),
    });
    _scheduleNotification(docRef.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _db.collection('tasks').doc(task.id).update(task.toMap());
    _scheduleNotification(task.id, task);
  }

  Future<void> deleteTask(String taskId) {
    return _db.collection('tasks').doc(taskId).delete();
  }

  void _scheduleNotification(String taskId, Task task) {
    final scheduledDate = task.deadline.subtract(const Duration(minutes: 10));
    _notificationService.scheduleNotification(
      taskId.hashCode,
      task.title,
      'Your task is due in 10 minutes!',
      scheduledDate,
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_task_manager/model/task.dart';
// import 'package:flutter/material.dart';
//
// class TaskService extends ChangeNotifier{
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   Stream<List<Task>> getTasks(String userId) {
//     return _db
//         .collection('tasks')
//         .where('userId', isEqualTo: userId)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => Task.fromMap(doc.data(), doc.id))
//         .toList());
//   }
//
//   Future<void> addTask(Task task, String userId) {
//     return _db.collection('tasks').add({
//       'userId': userId,
//       ...task.toMap(),
//     });
//   }
//
//   Future<void> updateTask(Task task) {
//     return _db.collection('tasks').doc(task.id).update(task.toMap());
//   }
//
//   Future<void> deleteTask(String taskId) {
//     return _db.collection('tasks').doc(taskId).delete();
//   }
// }
