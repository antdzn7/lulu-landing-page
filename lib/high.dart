import 'package:flutter/material.dart';

class High extends StatelessWidget {
  const High({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Priority'),
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
