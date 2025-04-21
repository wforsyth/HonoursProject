import 'package:flutter/material.dart';
import '../pieChart.dart';
import '../auth.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final Auth _auth = Auth();
  late List<String> months = [];

  @override
  void initState() {
    super.initState();
    _getMonths();
  }

//Gets previous 12 months from the current month
  void _getMonths() {
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      DateTime monthDate = DateTime(now.year, now.month - i, 1);
      String formatMonth =
          '${monthDate.month.toString().padLeft(2, '0')} ${monthDate.year}';
      months.add(formatMonth);
    }
    setState(() {});
  }

//Retrieves monthly data on medication reminders from backend database
  Future<Map<String, double>> _getMonthlyData(String month) async {
    return await _auth.getMonthlyData(month);
  }

//Displays monthly data in a pie chart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          String currentMonth = months[index];
          return FutureBuilder<Map<String, double>>(
            future: _getMonthlyData(currentMonth),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                Map<String, double> data = snapshot.data!;
                return MonthPieChart(month: currentMonth, data: data);
              } else {
                return Center(child: Text('No data available for this month'));
              }
            },
          );
        },
      ),
    );
  }
}
