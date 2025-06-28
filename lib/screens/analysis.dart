import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: 270,

              child: WeeklyWaterChart()),
        ],
      ),
    );
  }
}
class WeeklyWaterChart extends StatelessWidget {
  final List<double> dailyIntake = [1.2, 0.8, 1.5, 2.0, 1.7, 1.0, 2.2]; // in liters

  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 3, // max expected water intake in liters
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Colors.blueAccent,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${weekDays[groupIndex]}: ${rod.toY}L',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, meta) {
                  return Text(
                    weekDays[value.toInt()],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: dailyIntake.asMap().entries.map((entry) {
            int index = entry.key;
            double value = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                  width: 20,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
