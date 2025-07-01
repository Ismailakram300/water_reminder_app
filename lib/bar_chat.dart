import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'Database/database_helper.dart';

class TodayWaterChart extends StatefulWidget {
  const TodayWaterChart({super.key});

  @override
  State<TodayWaterChart> createState() => _TodayWaterChartState();
}

class _TodayWaterChartState extends State<TodayWaterChart> {
  int todayTotal = 0;
  String todayDateLabel = "";

  double _calculateMaxY(int total) {
    if (total <= 2000) return 2500;
    if (total <= 3000) return 4000;
    if (total <= 4000) return 5000;
    return ((total / 1000).ceil() * 1000 + 500).toDouble(); // margin above bar
  }

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    final total = await DatabaseHelper.instance.getTodayDrinkTotal();
    final now = DateTime.now();
    final label =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}";

    setState(() {
      todayTotal = total;
      todayDateLabel = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double dynamicMaxY = _calculateMaxY(todayTotal);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1,
            child: BarChart(
              BarChartData(
                maxY: dynamicMaxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          todayDateLabel,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: todayTotal.toDouble(),
                        width: 40,
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: dynamicMaxY,
                          color: Colors.lightBlue.withOpacity(0.2),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
