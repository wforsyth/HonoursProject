import 'package:flutter/material.dart';
import 'package:honours_project/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:honours_project/routes.dart';
import 'package:honours_project/auth.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  //Formats the calendar view
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Map<String, dynamic>>> selectedEvents = {};
  final Auth _auth = Auth();

//Normalises dateTime variable to ignore time and group events by day
  DateTime normaliseToDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

//Fetches reminder date from database
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

//Send updated reminder status ('taken' or 'missed') to backend
  Future<void> _updateReminderStatus(String reminderId, String status) async {
    try {
      await _auth.updateReminderStatus(status, reminderId);
      _fetchReminders();
    } catch (e) {
      print('Error logging status: $e');
    }
  }

//Updates data in backend whether medication was taken or not
  Future<void> _updateData(bool isTaken) async {
    try {
      await _auth.updateData(isTaken);
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  bool _reminderDue(String reminderTime) {
    DateTime now = DateTime.now();
    DateTime reminderDateTime = DateTime.parse(reminderTime);
    return now.isAfter(reminderDateTime);
  }

  bool _isStatusSet(String status) {
    return status == 'taken' || status == 'missed';
  }

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

//Displays interactive calendar API
//Displays medication reminders created by for the day the user has tapped on calender
//Allows user to interact with reminder when medication is due to be taken
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
                        String reminderDate = event['reminderDate'];
                        String reminderTime = event['reminderTime'];
                        DateTime reminderDateTime =
                            DateTime.parse('$reminderDate $reminderTime');
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
                                if (_reminderDue(
                                        reminderDateTime.toIso8601String()) &&
                                    !_isStatusSet(event['status']))
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _updateReminderStatus(
                                              event['reminderId'], 'taken');
                                          _updateData(true);
                                        },
                                        child: Text('Taken'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _updateReminderStatus(
                                              event['reminderId'], 'missed');
                                          _updateData(false);
                                        },
                                        child: Text('Missed'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                String reminderId =
                                    event['reminderId'].toString();
                                _auth.deleteReminder(reminderId).then((_) {
                                  setState(() {
                                    _fetchReminders();
                                  });
                                });
                              },
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
        backgroundColor: kPrimaryColor,
        foregroundColor: kScaffoldColor,
        tooltip: 'Add Medication Reminder',
      ),
    );
  }
}
