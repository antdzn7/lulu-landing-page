import 'package:flutter/material.dart';

class Low extends StatelessWidget {
  const Low({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Priority'),
      ),
      body: const Center(
        child: Text(
          '',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
