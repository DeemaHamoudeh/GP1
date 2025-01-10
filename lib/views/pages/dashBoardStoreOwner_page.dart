import 'package:flutter/material.dart';
import 'dart:core';

class DashboardStoreOwnerPage extends StatefulWidget {
  final String? token;

  const DashboardStoreOwnerPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  @override
  State<DashboardStoreOwnerPage> createState() => _DashboardStoreOwnerPage();
}

class _DashboardStoreOwnerPage extends State<DashboardStoreOwnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu, color: Colors.white),
            Icon(Icons.notifications, color: Colors.white),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hello, User!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Progress Tracker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.3, // Example progress value
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                  ),
                ),
                SizedBox(width: 10),
                Text('3/8 tasks completed'),
              ],
            ),
          ),
          // Upcoming Task Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.task, color: Colors.teal),
                title: Text('Upcoming Task'),
                subtitle: Text('Add your first product'),
                trailing: Icon(Icons.arrow_forward, color: Colors.teal),
              ),
            ),
          ),
          // Setup Guide Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Setup Guide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                TaskItem(
                  title: 'Add your product',
                  isCompleted: false,
                  onTap: () {
                    // Navigate to task page
                  },
                ),
                TaskItem(
                  title: 'Customize your online store',
                  isCompleted: true,
                  onTap: () {
                    // Navigate to task page
                  },
                ),
                TaskItem(
                  title: 'Add pages to your store',
                  isCompleted: false,
                  onTap: () {
                    // Navigate to task page
                  },
                ),
                // Add more tasks here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  TaskItem(
      {required this.title, required this.isCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: ListTile(
          leading: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.teal : Colors.grey,
          ),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward, color: Colors.teal),
          onTap: onTap,
        ),
      ),
    );
  }
}
