import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Done extends StatefulWidget {
  const Done({Key? key}) : super(key: key);

  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Done Tasks',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('done').snapshots(),
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
                  'No done tasks available',
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

                return DoneTaskCard(
                  title: title,
                  details: details,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DoneTaskCard extends StatefulWidget {
  final String title;
  final String details;

  const DoneTaskCard({
    required this.title,
    required this.details,
    Key? key,
  }) : super(key: key);

  @override
  _DoneTaskCardState createState() => _DoneTaskCardState();
}

class _DoneTaskCardState extends State<DoneTaskCard> {
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

    return GestureDetector(
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
                  const Icon(Icons.done, color: Colors.green),
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
                  color: Colors.green[50],
                  child: Text(
                    widget.details,
                    style: TextStyle(color: priorityColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
