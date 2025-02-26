import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:honours_project/routes.dart';
import 'package:honours_project/auth.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Map<String, dynamic>>> selectedEvents = {};
  final Auth _auth = Auth();

  DateTime normaliseToDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _fetchReminders() async {
    try {
      List<Map<String, dynamic>> reminders = await _auth.getReminders();

      selectedEvents.clear();

      for (var reminder in reminders) {
        String reminderDateString = reminder['reminderDate'];
        DateTime reminderDate = DateTime.parse(reminderDateString);
        DateTime normalisedReminderDate = normaliseToDay(reminderDate);

        if (selectedEvents[normalisedReminderDate] == null) {
          selectedEvents[normalisedReminderDate] = [];
        }
        selectedEvents[normalisedReminderDate]!.add(reminder);
      }
      setState(() {});
    } catch (e) {
      print('Error getting reminders $e');
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    DateTime normalisedDay = normaliseToDay(day);
    return selectedEvents[normalisedDay] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2033, 12, 31),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _selectedDay != null &&
                      _getEventsForDay(_selectedDay!).isNotEmpty
                  ? ListView.builder(
                      itemCount: _getEventsForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final event = _getEventsForDay(_selectedDay!)[index];
                        return Card(
                          child: ListTile(
                            title: Text(event['medicineName']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dosage: ${event['dosage']} mg'),
                                Text('Medicine Type: ${event['medicineType']}'),
                                Text('Reminder Date: ${event['reminderDate']}'),
                                Text('Reminder Time: ${event['reminderTime']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No medication reminders for today.')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.medEntry).then((_) {
            _fetchReminders();
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add Medication Reminder',
      ),
    );
  }
}
