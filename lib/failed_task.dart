import 'package:flutter/material.dart';

class Failedtask extends StatefulWidget {
  const Failedtask({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FailedtaskState createState() => _FailedtaskState();
}

class _FailedtaskState extends State<Failedtask> {
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Submit project proposal',
      'details': 'High priority\nDue date: September 23, 2024',
      'expanded': false
    },
    {
      'title': 'Clean the kitchen',
      'details': 'Low priority',
      'expanded': false
    },
    {'title': 'Do laundry', 'details': 'Medium priority', 'expanded': false},
    {'title': 'Create website', 'details': 'High priority', 'expanded': false},
    {'title': 'Change bed sheet', 'details': 'Low priority', 'expanded': false},
    {
      'title': 'Project presentation on Friday',
      'details': 'High priority',
      'expanded': false
    },
  ];

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      tasks[index]['expanded'] = !tasks[index]['expanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  "Failed Tasks",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.close, color: Colors.red, size: 30),
              ],
            ),
            Text(
              '${tasks.length} failed to finish',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(tasks[index]['title']),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await _showDeleteConfirmation();
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteTask(index);
            },
            child: GestureDetector(
              onTap: () => _toggleExpand(index),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error,
                              color: Colors.red), // Red icon
                          const SizedBox(
                              width: 10), // Spacing between icon and text
                          Expanded(
                            child: Text(
                              tasks[index]['title'] as String,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            tasks[index]['expanded'] as bool
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                      if (tasks[index]['expanded'] as bool)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          color: Colors.red[50],
                          child: Text(
                            tasks[index]['details'] as String,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation() {
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
