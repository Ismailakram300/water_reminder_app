import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../Database/database_helper.dart'; // Adjust path if needed

class TodayWaterChart extends StatefulWidget {
  const TodayWaterChart({super.key});

  @override
  State<TodayWaterChart> createState() => _TodayWaterChartState();
}

class _TodayWaterChartState extends State<TodayWaterChart> {
  int todayTotal = 0;
  String todayDateLabel = "";
  double computedMaxY(double total) {
    if (total <= 2000) return 2500;
    if (total <= 3000) return 3500;
    if (total <= 4000) return 4500;
    return ((total / 1000).ceil() * 1000).toDouble() + 2000; // add margin
  }

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    final total = await DatabaseHelper.instance.getTodayDrinkTotal();

    final now = DateTime.now();
    final label = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}";

    setState(() {
      todayTotal = total;
      todayDateLabel = label;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            aspectRatio: 1.2,
            child: BarChart(
              BarChartData(
                maxY:  computedMaxY(todayTotal.toDouble()),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      getTitlesWidget: (value, _) {
                        return Text(todayDateLabel);
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 0.8),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: todayTotal.toDouble(),
                        color: Colors.lightBlue,
                        width: 30,
                        borderRadius: BorderRadius.circular(4),
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
