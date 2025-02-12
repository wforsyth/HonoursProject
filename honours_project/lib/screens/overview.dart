import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Overview extends StatefulWidget{
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
              onDaySelected: (selectedDay, focusedDay){
                setState((){
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format){
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay){
                _focusedDay = focusedDay;
              },
              ),
              SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}