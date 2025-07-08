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
import 'package:water_reminder_app/customs_widgets/mytext.dart';
import 'package:water_reminder_app/screens/weekly_water_chart.dart';

import '../Database/database_helper.dart';
import '../Models/drinks_log.dart';
import '../bar_chat.dart';

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
        backgroundColor: Colors.blue,
       // elevation: 0,
        title: Text('Analysis', style: TextStyle(fontSize: 20)),
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
                  'Total: $totalDrank ml',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
               // SizedBox(height: 10),
                Container( child: WeeklyWaterChart()),
              ],
            ),
          ),

          // Drink, Total, Goal Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statBox('Drink', '$drinkCount cups', Color(0xffD3F3FE)!,Color(0xff278DE8)),
                _statBox('Total', '$totalDrank ml', Color(0xffFFEEDF)!,Color(0xffC65900)),
                _statBox('Goal', '$dailyGoal ml', Color(0xffD3F3FE)!,Color(0xff26A644)),
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
                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height:50,
                            width: 100,
                            child: Image.asset(
                              fit: BoxFit.contain,
                              log.imagePath,

                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.local_drink,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ),
                  Column(
                    children: [
                      Mytext(txt: '${log.amount} ml',size: 17,),
                       Text(timeStr),

                    ],
                  )

                        ],
                      ),
                      // ListTile(
                      //   leading: Image.asset(
                      //     log.imagePath,
                      //     height: 52,
                      //     width: 52,
                      //     errorBuilder: (context, error, stackTrace) => Icon(
                      //       Icons.local_drink,
                      //       color: Colors.blue,
                      //       size: 30,
                      //     ),
                      //   ),
                      //   title:
                      //
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(thickness: 1, color: Colors.black),
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

  Widget _statBox(String label, String value, Color color ,Color txtColor) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Color(0xff525252))),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: txtColor)),
        ],
      ),
    );
  }
}
