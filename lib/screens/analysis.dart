// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Analysis extends StatefulWidget {
//   const Analysis({super.key});
//
//   @override
//   State<Analysis> createState() => _AnalysisState();
// }
//
// class _AnalysisState extends State<Analysis> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//               height: 270,
//
//               child: WeeklyWaterChart()),
//         ],
//       ),
//     );
//   }
// }
// class WeeklyWaterChart extends StatelessWidget {
//   final List<double> dailyIntake = [1.2, 0.8, 1.5, 2.0, 1.7, 1.0, 2.2]; // in liters
//
//   final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.4,
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 3, // max expected water intake in liters
//           barTouchData: BarTouchData(
//             enabled: true,
//             touchTooltipData: BarTouchTooltipData(
//               // tooltipBgColor: Colors.blueAccent,
//               getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                 return BarTooltipItem(
//                   '${weekDays[groupIndex]}: ${rod.toY}L',
//                   TextStyle(color: Colors.white),
//                 );
//               },
//             ),
//           ),
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, meta) {
//                   return Text(
//                     weekDays[value.toInt()],
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   );
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           barGroups: dailyIntake.asMap().entries.map((entry) {
//             int index = entry.key;
//             double value = entry.value;
//             return BarChartGroupData(
//               x: index,
//               barRods: [
//                 BarChartRodData(
//                   toY: value,
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(4),
//                   width: 20,
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../Database/database_helper.dart';
import '../Models/drinks_log.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await DatabaseHelper.instance.getTodayLogs();
    final userData = await DatabaseHelper.instance.getUserData();

    setState(() {
      waterLogs = logs;
      totalDrank = logs.fold(0, (sum, item) => sum + item.amount);
      drinkCount = logs.length;
      dailyGoal = userData?['dailyGoal'] ?? 2000;
    });
  }

  List<DrinkLog> waterLogs = [];
  int totalDrank = 0;
  int drinkCount = 0;
  int dailyGoal = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFE),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[300],
        elevation: 0,
        title: Text('19/06/2025', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bar Chart Section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Total: 3150 ml',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                Container(height: 200, child: TodayWaterChart()),
              ],
            ),
          ),

          // Drink, Total, Goal Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statBox('Drink', '$drinkCount cups', Colors.lightBlue[100]!),
                _statBox('Total', '$totalDrank ml', Colors.orange[100]!),
                _statBox('Goal', '$dailyGoal ml', Colors.cyan[100]!),
              ],
            ),
          ),

          // Drink Logs
          Expanded(
            child: ListView.builder(
              itemCount: waterLogs.length,
              itemBuilder: (context, index) {
                final log = waterLogs[index];
                final timeStr =
                    "${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}";

                return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          log.imagePath,
                          height: 42,
                          width: 42,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.local_drink,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        title: Text('${log.amount} ml'),
                        subtitle: Text(timeStr),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(thickness: 2, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.black54)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// class BarChartPainter extends CustomPainter {
//   final int value;
//
//   BarChartPainter({required this.value});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final barPaint = Paint()..color = Colors.blueAccent;
//     final textPainter = TextPainter(textDirection: TextDirection.ltr);
//
//     double maxHeight = 5000;
//     double barHeight = (value / maxHeight) * size.height;
//
//     // Draw bar
//     canvas.drawRect(
//       Rect.fromLTWH(size.width / 2 - 20, size.height - barHeight, 40, barHeight),
//       barPaint,
//     );
//
//     // Draw text
//     textPainter.text = TextSpan(
//       text: '$value',
//       style: TextStyle(color: Colors.black, fontSize: 14),
//     );
//     textPainter.layout();
//     textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - barHeight - 20));
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

