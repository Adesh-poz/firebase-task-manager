import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:firebase_task_manager/constants.dart';
import 'package:firebase_task_manager/model/task.dart';
import 'package:firebase_task_manager/services/task_service.dart';
import 'package:firebase_task_manager/screens/task_form_screen.dart';
import 'package:firebase_task_manager/reusables/shimmering_text_widget.dart';
import 'package:firebase_task_manager/reusables/color_gradiant_bg.dart';
import 'package:firebase_task_manager/screens/login_screen.dart';

/// The home page of the Task Manager app.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: primaryBGColor,
      drawer: Drawer(
        backgroundColor: secondaryBGColor,
        child: Container(
          decoration: gradientBGDecoration(drawerPrimaryBGColor, Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // User Name Display Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 80.0, horizontal: 20.0),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    user?.displayName ?? 'Welcome, User',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Divider separating the User Name Display and the Logout Button Section
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black54,
                indent: 30,
                endIndent: 30,
              ),

              //Log Out Button
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.logout_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              '   Log Out',
                              style: TextStyle(
                                fontFamily: GoogleFonts.ubuntu().fontFamily,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Credits Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Made with ♥️ by Adesh',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: GoogleFonts.notoSerif().fontFamily,
                      fontSize: 15,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: homeScreenPrimaryBGColor,
        elevation: 6.0,
        shadowColor: Colors.black,
        title: ShimmeringTextWidget(
          text: 'Task Manager',
          style: TextStyle(
            fontFamily:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold).fontFamily,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          // Add new Task Button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TaskFormScreen()),
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: gradientBGDecoration(
            homeScreenPrimaryBGColor, homeScreenSecondaryBGColor),
        child: StreamBuilder<List<Task>>(
          stream: taskService.getTasks(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            }
            final tasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    taskService.deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${task.title} dismissed')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    elevation: 4,
                    color: task.isComplete ? Colors.grey.shade400 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskFormScreen(task: task),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Task'),
                            content: const Text(
                                'Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  taskService.deleteTask(task.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  task.isComplete ? "(Completed)" : "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Deadline: ${DateFormat.yMd().add_jm().format(task.deadline)}', // Ensure you have imported DateFormat
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Checkbox(
                                  value: task.isComplete,
                                  onChanged: (value) {
                                    task.isComplete = value!;
                                    taskService.updateTask(task);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      // FloatingActionButton to add new Tasks.
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryBGColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
