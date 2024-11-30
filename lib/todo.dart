import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To Do",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task count subtitle
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('smartpd').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (snapshot.hasError) {
                  return const Text('Error loading tasks');
                }

                final tasks = snapshot.data?.docs ?? [];
                final taskCount = tasks.length;

                return Text(
                  "$taskCount task${taskCount == 1 ? '' : 's'} in the queue",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Task list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('smartpd').snapshots(),
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
                        'No tasks available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final taskData = tasks[index].data() as Map<String, dynamic>;
                      final docId = tasks[index].id;
                      final title = taskData['description'] ?? 'Untitled Task';
                      final details =
                          'Priority: ${taskData['priority'] ?? 'None'}\nDue Date: ${taskData['due_date'] ?? 'Not Set'}\nDue Time: ${taskData['due_time'] ?? 'Not Set'}';

                      return TaskCard(
                        title: title,
                        details: details,
                        onDone: () => _markTaskAsDone(docId, taskData),
                        onDismiss: () => _deleteTask(docId),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markTaskAsDone(String docId, Map<String, dynamic> taskData) {
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

  void _deleteTask(String docId) {
    FirebaseFirestore.instance.collection('smartpd').doc(docId).delete();
  }
}

class TaskCard extends StatefulWidget {
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
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isExpanded = false;

  // Helper function to get color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.yellow[700]!;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract priority from details
    final RegExp priorityRegex = RegExp(r'Priority: (\w+)', caseSensitive: false);
    final match = priorityRegex.firstMatch(widget.details);
    final priority = match?.group(1) ?? 'None';
    final priorityColor = _getPriorityColor(priority);

    return Dismissible(
      key: ValueKey(widget.title),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onDone();
          return false; // Prevent default dismissal
        } else if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        child: const Icon(Icons.done, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onDismiss();
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Card(
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
                        widget.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
                if (_isExpanded)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    color: Colors.blue[50],
                    child: Text(
                      widget.details,
                      style: TextStyle(color: priorityColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task?"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
