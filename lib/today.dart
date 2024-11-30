import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    // Get today's date in 'yyyy-MM-dd' format
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('smartpd')
              .where('due_date', isEqualTo: todayDate) // Filter tasks by today's date
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading tasks'));
            }

            final tasks = snapshot.data?.docs ?? [];

            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No tasks for today',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final taskData = tasks[index].data() as Map<String, dynamic>;
                final title = taskData['description'] ?? 'Untitled Task';
                final details =
                    'Priority: ${taskData['priority'] ?? 'None'}\nDue Date: ${taskData['due_date'] ?? 'Not Set'}\nDue Time: ${taskData['due_time'] ?? 'Not Set'}';

                return TaskCard(
                  title: title,
                  details: details,
                  onDone: () => _markTaskAsDone(context, tasks[index].id, taskData),
                  onDismiss: () => _deleteTask(context, tasks[index].id),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _markTaskAsDone(BuildContext context, String docId, Map<String, dynamic> taskData) {
    final doneCollection = FirebaseFirestore.instance.collection('done');
    final originalCollection = FirebaseFirestore.instance.collection('smartpd');

    // Add task to the 'done' collection
    doneCollection.add(taskData).then((value) {
      // Delete the task from the original collection
      originalCollection.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task marked as done!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark task as done: $error')),
      );
    });
  }

  void _deleteTask(BuildContext context, String docId) {
    FirebaseFirestore.instance.collection('smartpd').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted')),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String details;
  final VoidCallback onDone;
  final VoidCallback onDismiss;

  const TaskCard({
    required this.title,
    required this.details,
    required this.onDone,
    required this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.pending_actions_outlined, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.done, color: Colors.green),
                  onPressed: onDone,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDismiss,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Colors.blue[50],
              child: Text(details),
            ),
          ],
        ),
      ),
    );
  }
}
