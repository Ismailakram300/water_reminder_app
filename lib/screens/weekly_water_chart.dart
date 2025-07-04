import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../Database/database_helper.dart';

class WeeklyWaterChart extends StatefulWidget {
  const WeeklyWaterChart({super.key});

  @override
  State<WeeklyWaterChart> createState() => _WeeklyWaterChartState();
}

class _WeeklyWaterChartState extends State<WeeklyWaterChart> {

  List<double> dailyIntake = List.filled(7, 0.0); // Defaults to 0.0
  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();

    _loadWeeklyData();
  }

  Future<void> _loadWeeklyData() async {

    final data = await DatabaseHelper.instance.getWeeklyDrinkSummary();
    Map<String, double> intakeMap = {};

    for (var entry in data) {
      DateTime date = DateTime.parse(entry['day']);
      double totalLiters = (entry['total'] as int) / 1000; // convert ml to liters
      String weekday = weekDays[date.weekday - 1];
      intakeMap[weekday] = totalLiters;
    }

    // Populate dailyIntake list based on weekdays
    setState(() {
      dailyIntake = weekDays.map((day) => intakeMap[day] ?? 0.0).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxIntake = dailyIntake.reduce((a, b) => a > b ? a : b);
    double maxY = (maxIntake + 0.5).ceilToDouble(); // Add some padding

    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY, // max expected intake
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${weekDays[groupIndex]}: ${rod.toY.toStringAsFixed(1)}L',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    weekDays[value.toInt()],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}L',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  );
                },
              ),
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
