import 'package:flutter/material.dart';

class MedEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Medication Entry Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Add journal entry');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Journal Entry',
      ),
    );
  }
}