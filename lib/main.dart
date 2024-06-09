import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:firebase_task_manager/screens/login_screen.dart';
import 'package:firebase_task_manager/services/task_service.dart';

/// The main entry point for the application.
/// Initializes Firebase and sets up timezones before running the app.
Future<void> main() async {
  // Ensure that Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase services.
  await Firebase.initializeApp();

  // Initialize timezones data.
  tz.initializeTimeZones();

  // Run the Task Manager app.
  runApp(const TaskManagerApp());
}

/// The main application widget that builds the app tree.
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for managing tasks.
        ChangeNotifierProvider(create: (_) => TaskService()),
        // Add other providers here if needed.
      ],
      child: const MaterialApp(
        // Disable debug banner in release mode.
        debugShowCheckedModeBanner: false,
        // Set the initial screen to the Login Screen.
        home: LoginScreen(),
        // Add routes and other configurations here.
      ),
    );
  }
}
