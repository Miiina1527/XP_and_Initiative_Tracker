import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implementation ToDo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• KonamiDetector implemented (unit tests pending)'),
            SizedBox(height: 8),
            Text('• ExtrasScreen implemented (needs audio dependency)'),
            SizedBox(height: 8),
            Text('• Settings provider implemented (needs init at main)'),
            SizedBox(height: 8),
            Text('• Add d8 image and bell sound assets'),
            SizedBox(height: 8),
            Text('• Wire selector to read extras_unlocked (pending)'),
          ],
        ),
      ),
    );
  }
}
