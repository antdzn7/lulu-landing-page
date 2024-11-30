import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  Aboutus({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 171),
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.green.shade800,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 280), // Space for logo section
                        // Objectives Section
                        const Text(
                          'Objectives',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 1),
                        const Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          color: Color.fromARGB(255, 230, 230, 220),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 200,
                              child: Row(
                                children: [
                                  Icon(Icons.task, size: 60, color: Colors.green),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Help users manage tasks efficiently.',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        // Prioritization Cards
                        const Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          color: Color.fromARGB(255, 230, 230, 220),
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.priority_high, size: 60, color: Colors.blue),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Prioritize tasks based on urgency and deadlines.',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          color: Color.fromARGB(255, 230, 230, 220),
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.alarm, size: 60, color: Colors.orange),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Boost productivity with smart reminders and automation.',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        // About App Section
                        const Text(
                          'About App',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            'Our SMART Prio-Do app leverages advanced task management strategies. It helps you stay on top of your schedule by combining task prioritization with reminders. With automated notifications and personalized recommendations, you can focus on what matters most. Whether for work or personal tasks, our app adapts to your needs.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 30)),
                        const SizedBox(height: 44),
                        // Contact Information Section
                        const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email Contact
                        const ListTile(
                          leading: Icon(Icons.email, color: Colors.black),
                          title: Text('smartpriodo@gmail.com'),
                        ),

                        // Facebook Contact
                        const ListTile(
                          leading: Icon(Icons.facebook, color: Colors.blue),
                          title: Text('https://www.facebook.com/smartpriodo'),
                        ),

                        // Phone Contact
                        const ListTile(
                          leading: Icon(Icons.phone, color: Colors.black),
                          title: Text('+639876543211'),
                        ),

                        const Spacer(),
                        // Back to Top Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                            ),
                            child: const Text('Back to Top'),
                          ),
                        ),
                      ],
                    ),
                    // Updated Logo and Intro Section
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'SMART',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              height: 1.0,
                            ),
                          ),
                          const Text(
                            'PRIO-DO',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'To help you stay\norganized, and\nprioritize what\nmatters most.',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 185, 185, 171),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: const Text(
                              'Contact Us',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
