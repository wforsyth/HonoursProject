import 'package:flutter/material.dart';

class EmergencyContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Emergency Contact'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Emergency Contact page');
        },
        child: Icon(Icons.add_alarm),
        tooltip: 'Add Reminder',
      ),
    );
  }
}