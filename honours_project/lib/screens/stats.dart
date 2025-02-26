import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Analytics Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add medication reminder');
        },
        child: Icon(Icons.add_alarm),
        tooltip: 'Add Reminder',
      ),
    );
  }
}