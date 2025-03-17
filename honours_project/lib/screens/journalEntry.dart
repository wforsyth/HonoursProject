import 'package:flutter/material.dart';
import '../constants.dart';
import '../Auth.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Epialarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Journal Entry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _selectDate,
                  style: TextButton.styleFrom(
                    foregroundColor: kOtherColor,
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: _selectTime,
                  style: TextButton.styleFrom(
                    foregroundColor: kOtherColor,
                  ),
                  child: Text(_selectedTime == null
                      ? 'Select Time'
                      : 'Time: ${_selectedTime!.format(context)}'),
                ),
              ],
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description of seizure',
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              maxLines: 4,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.black),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kOtherColor,
                    foregroundColor: Colors.black),
                onPressed: () {
                  if (_selectedDate != null &&
                      _selectedTime != null &&
                      _descriptionController.text.isNotEmpty) {
                    String date =
                        _selectedDate!.toLocal().toString().split(' ')[0];
                    String time = _selectedTime!.format(context);
                    String description = _descriptionController.text;

                    try {
                      Auth().createJournalEntry(
                          time: time, date: date, description: description);
                      Navigator.pop(context);
                    } catch (e) {
                      print("Error saving journal entry: $e");
                    }
                  }
                },
                child: Text('Save Journal Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
