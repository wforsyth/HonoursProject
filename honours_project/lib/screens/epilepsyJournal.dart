import 'package:flutter/material.dart';

class EpilepsyJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Epilepsy Journal Page'),
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