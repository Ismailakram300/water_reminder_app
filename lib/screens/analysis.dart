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
import 'package:intl/intl.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';
import 'package:water_reminder_app/screens/weekly_water_chart.dart';

import '../Database/database_helper.dart';
import '../Models/drinks_log.dart';
import '../bar_chat.dart';
import 'history.dart';

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
    final logs = await DatabaseHelper.instance.getAllLogs();
    final userData = await DatabaseHelper.instance.getUserData();

    setState(() {
      waterLogs = logs;
      totalDrank = logs.fold(0, (sum, item) => sum + item.amount);
      drinkCount = logs.length;
      dailyGoal = userData?['dailyGoal'] ?? 2000;
    });
  }

  Map<String, List<DrinkLog>> _groupLogsByDate(List<DrinkLog> logs) {
    final Map<String, List<DrinkLog>> grouped = {};

    for (var log in logs) {
      String dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(log);
    }

    return grouped;
  }

  List<DrinkLog> waterLogs = [];
  int totalDrank = 0;
  int drinkCount = 0;
  int dailyGoal = 2000;

  @override
  Widget build(BuildContext context) {
    final groupedLogs = _groupLogsByDate(waterLogs);
    final sortedKeys = groupedLogs.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // newest first
    return Scaffold(
      backgroundColor: Color(0xffFAFBFE),
      appBar: AppBar(
      //  backgroundColor: Color(0xff),
        backgroundColor: Color(0xff278DE8),
        automaticallyImplyLeading: true,

        // elevation: 0,
        title: Text(
          'Analysis',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 👈 back to previous screen
          },
        ),
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
                Container(child: WeeklyWaterChart()),
              ],
            ),
          ),

          // Drink, Total, Goal Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statBox(
                  'Drink',
                  '$drinkCount cups',
                  Color(0xffD3F3FE)!,
                  Color(0xff278DE8),
                ),
                _statBox(
                  'Total',
                  '$totalDrank ml',
                  Color(0xffFFEEDF)!,
                  Color(0xffC65900),
                ),
                _statBox(
                  'Goal',
                  '$dailyGoal ml',
                  Color(0xffD3F3FE)!,
                  Color(0xff26A644),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final dateKey = sortedKeys[index];
                final logsForDate = groupedLogs[dateKey]!;

                final formattedDate = DateFormat(
                  'MMM d, yyyy',
                ).format(DateTime.parse(dateKey));

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📅 Date Heading
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,

                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E3E3E),
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff278DE8),
                              ),
                              width: 77,
                              height: 27,
                              child: Center(
                                child: Mytext(

                                  txt: "Total Drank",
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // 🔽 List of logs for this date
                      ...logsForDate.map((log) {
                        final timeStr = DateFormat(
                          'h:mm a',
                        ).format(log.timestamp);
                        return Card(
                          color: Color(0xffEFF7FF),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Image.asset(
                              log.imagePath,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.local_drink),
                            ),
                            title: Text('${log.amount} ml'),
                            subtitle: Text(timeStr),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),

          // Drink Logs
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: waterLogs.length,
          //     itemBuilder: (context, index) {
          //       final log = waterLogs[index];
          //       final dateTimeStr = DateFormat('MMM d, yyyy – h:mm a').format(log.timestamp);
          //
          //       return Padding(
          //         padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          //         child: Column(
          //           children: [
          //             Card(
          //               color: Color(0xffEFF7FF),
          //               elevation: 4, // Shadow depth
          //             //  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(12),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(10),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: [
          //                     SizedBox(
          //                       height: 43,
          //                       width: 100,
          //                       child: Image.asset(
          //                         log.imagePath,
          //                         fit: BoxFit.contain,
          //                         errorBuilder: (context, error, stackTrace) => Icon(
          //                           Icons.local_drink,
          //                           color: Colors.blue,
          //                           size: 24,
          //                         ),
          //                       ),
          //                     ),
          //                     const SizedBox(width: 2), // Space between image and text
          //                     Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Mytext(txt: '${log.amount} ml', size: 13,),
          //                         Text(
          //                           dateTimeStr,
          //                           style: TextStyle(color: Colors.grey[600], fontSize: 11,                      fontFamily: 'Mulish',
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //
          //             // ListTile(
          //             //   leading: Image.asset(
          //             //     log.imagePath,
          //             //     height: 52,
          //             //     width: 52,
          //             //     errorBuilder: (context, error, stackTrace) => Icon(
          //             //       Icons.local_drink,
          //             //       color: Colors.blue,
          //             //       size: 30,
          //             //     ),
          //             //   ),
          //             //   title:
          //             //
          //             // ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),

      // Bottom Navigation
    );
  }

  Widget _statBox(String label, String value, Color color, Color txtColor) {
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
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: txtColor),
          ),
        ],
      ),
    );
  }
}
