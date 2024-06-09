import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:firebase_task_manager/model/task.dart';
import 'package:firebase_task_manager/reusables/color_gradiant_bg.dart';
import 'package:firebase_task_manager/services/task_service.dart';
import 'package:firebase_task_manager/constants.dart';

/// This class contains the UI and logic for creating and editing tasks.
class TaskFormScreen extends StatefulWidget {
  final Task? task; // Task to edit, or null for creating a new task

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  DateTime? _deadline;
  Duration? _expectedDuration;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    // Initialize fields if editing an existing task
    // or set default values if creating a new task
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _deadline = widget.task!.deadline;
      _expectedDuration = widget.task!.expectedDuration;
      _isComplete = widget.task!.isComplete;
    } else {
      _title = '';
      _description = '';
      _deadline = DateTime.now();
      _expectedDuration = const Duration(minutes: 60);
    }
  }

  /// Opens date picker and time picker dialogs to select a deadline.
  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        setState(() {
          _deadline = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  /// Validates and submits the form, adding or updating the task.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskService = Provider.of<TaskService>(context, listen: false);
      final task = Task(
        id: widget.task?.id ?? '',
        title: _title,
        description: _description,
        deadline: _deadline!,
        expectedDuration: _expectedDuration!,
        isComplete: _isComplete,
      );
      if (widget.task == null) {
        // Adding a new task
        taskService.addTask(task, FirebaseAuth.instance.currentUser!.uid);
      } else {
        // Updating an existing task
        taskService.updateTask(task);
      }
      Navigator.of(context).pop(); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 6.0,
        backgroundColor: homeScreenPrimaryBGColor,
        shadowColor: Colors.black,
        title: Text(
          widget.task == null ? 'New Task' : 'Edit Task',
          style: TextStyle(
            fontFamily:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold).fontFamily,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submit, // Save the task when the save button is pressed
          ),
        ],
      ),
      body: Container(
        decoration: gradientBGDecoration(
            homeScreenPrimaryBGColor, homeScreenSecondaryBGColor),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                ListTile(
                  title:
                      Text('Deadline: ${DateFormat.yMd().format(_deadline!)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDeadline(
                      context), // Select the deadline when tapped
                ),
                TextFormField(
                  initialValue: _expectedDuration!.inMinutes.toString(),
                  decoration: const InputDecoration(
                      labelText: 'Expected Duration (in minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _expectedDuration = Duration(minutes: int.parse(value!));
                  },
                ),
                SwitchListTile(
                  title: const Text('Complete'),
                  value: _isComplete,
                  onChanged: (value) {
                    setState(() {
                      _isComplete = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
