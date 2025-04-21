import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MonthPieChart extends StatelessWidget {
  final String month;
  final Map<String, double> data;

  MonthPieChart({required this.month, required this.data});

//Display for pie chart widget called in stats screen
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          PieChart(
            dataMap: data,
            chartType: ChartType.ring,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 2.5,
            colorList: [Colors.green, Colors.red],
            initialAngleInDegree: 0,
            ringStrokeWidth: 32,
            legendOptions: LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 0,
            ),
          ),
        ],
      ),
    );
  }
}
