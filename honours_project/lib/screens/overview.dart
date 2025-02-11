import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              child: ListTile(
                title: Text('Next Medication Reminder'),
                subtitle: Text('8:00 AM - 01/22/2025'),
                trailing: Icon(Icons.alarm),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: ListTile(
                title: Text('Recent Journal Entry'),
                subtitle: Text('Had a slight headache in the morning.'),
                trailing: Icon(Icons.book),
              ),
            ),
          ],
        ),
      ),
    );
  }
}