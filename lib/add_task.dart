import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import Firestore

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Task',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFEAF7FA),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Task', style: TextStyle(color: Colors.black)),
          backgroundColor: const Color(0xFFEAF7FA),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPriority;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Add task description...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 5, 
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Due date'
                        : DateFormat.yMd().format(_selectedDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime == null
                        ? 'Due time'
                        : _selectedTime!.format(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.access_time, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            hint: const Text('Priority Level'),
            items: ['Low Level', 'Medium Level', 'High Level']
                .map((priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedPriority = value;
              });
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final String description = _descriptionController.text;
                final String dueDate = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '';
                final String dueTime = _selectedTime != null ? _selectedTime!.format(context) : '';
                final String priority = _selectedPriority ?? '';

                Task newTask = Task(
                  description: description,
                  dueDate: dueDate,
                  dueTime: dueTime,
                  priority: priority,
                );

                setState(() {
                  _isLoading = true;
                });

                // Save the task to Firestore
                await FirebaseFirestore.instance.collection('smartpd').add(newTask.toMap());

                setState(() {
                  _isLoading = false;
                  _descriptionController.clear();
                  _selectedDate = null;
                  _selectedTime = null;
                  _selectedPriority = null;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: const Color(0xFF53C7B1),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Add', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class Task {
  final String? id;
  final String description;
  final String dueDate;
  final String dueTime;
  final String priority;

  Task({this.id, required this.description, required this.dueDate, required this.dueTime, required this.priority});

  // Convert Task to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'due_date': dueDate,
      'due_time': dueTime,
      'priority': priority,
    };
  }

  // Create a Task from a Firestore document
  static Task fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      description: map['description'] ?? '',
      dueDate: map['due_date'] ?? '',
      dueTime: map['due_time'] ?? '',
      priority: map['priority'] ?? '',
    );
  }
}
