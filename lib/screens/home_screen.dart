import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';

import '../Database/database_helper.dart';
import '../Models/drink_options.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    _loadProgress();
    _loadImageFromDatabase();
  }

  String selectedImage = 'assets/images/glass-water.png'; // default image
  int selectedMl = 100;
  int dailyGoal = 250;
  int todayDrank = 0;
  double _counter = 0.0;
  int percentage=0;
  // List<String> imageOptions = [
  //   'assets/images/glass-water.png',
  //   'assets/images/bottle.png',
  //   'assets/images/cup.png',
  //   'assets/images/mug.png',
  // ];
  Future<void> _loadImageFromDatabase() async {
    final data = await DatabaseHelper.instance.getUserData();
    if (data != null) {
      print(
        "Loaded from DB: ${data['selectedImage']} | ml: ${data['selectedMl']} | dailyGoal: ${data['dailyGoal']}",
      ); // Debug log
      setState(() {
        selectedImage =
            data['selectedImage'] ?? 'assets/images/glass-water.png';
        selectedMl = data['selectedMl'] ?? 100;
        dailyGoal=data['dailyGoal'] ?? 250;
      });
    }
  }
  Future<void> _loadProgress() async {
    final userData = await DatabaseHelper.instance.getUserData();
    final drank = await DatabaseHelper.instance.getTodayDrinkTotal();

    setState(() {
      dailyGoal = userData?['dailyGoal'] ?? 2000;
      todayDrank = drank;
      _counter = (todayDrank / dailyGoal).clamp(0.0, 1.0);
      // Optional: percentage = (_counter * 100).toInt();
    });
  }

  Future<void> _addDrink(int ml, String path) async {
    // 1. Save the drink log
    await DatabaseHelper.instance.saveDrinkLog(amount: ml, imagePath: path);

    // 2. Get updated total and user data
    final userData = await DatabaseHelper.instance.getUserData();
    final drank = await DatabaseHelper.instance.getTodayDrinkTotal();
    final isGoalDone = await DatabaseHelper.instance.isTargetAchieved();

    // 3. Update the state to refresh progress bar
    setState(() {
      dailyGoal = userData?['dailyGoal'] ?? 2000;
      todayDrank = drank;
      _counter = (todayDrank / dailyGoal).clamp(0.0, 1.0);
      int percentage = (_counter * 100).toInt();

    });

    // 4. Print debug messages
    print('Total drank today: $todayDrank ml');
    print(isGoalDone ? '🎉 Goal Achieved!' : '💧 Keep going!');
  }

  Future<void> _saveImageAndMlToDatabase(String imagePath, int ml) async {
    final existingData = await DatabaseHelper.instance.getUserData();
    if (existingData != null) {
      print("Saving image: $imagePath | ml: $ml"); // Debug log
      await DatabaseHelper.instance.saveUserData(
        gender: existingData['gender'],
        weight: existingData['weight'],
        dailyGoal: existingData['dailyGoal'],
        wakeUp: existingData['wakeUpTime'],
        sleep: existingData['sleepTime'],
        selectedImage: imagePath,
        selectedMl: ml,
      );
    }
  }


  void _showDrinkSelector() {
    int? tempSelectedMl = selectedMl;
    String? tempSelectedImage = selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Select Drink"),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 250, // ✅ give it a height
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        children: drinkOptions.map((option) {
                          final isSelected = tempSelectedMl == option.ml;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempSelectedMl = option.ml;
                                tempSelectedImage = option.imagePath;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(option.imagePath, height: 39),
                                  SizedBox(height: 8),
                                  Text('${option.ml}ml'),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  //  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),

                height: 40,
                width: 70,
                child: Center(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                if (tempSelectedMl != null && tempSelectedImage != null) {
                  setState(() {
                    selectedMl = tempSelectedMl!;
                    selectedImage = tempSelectedImage!;
                  });

                  await _saveImageAndMlToDatabase(selectedImage, selectedMl);

                  Navigator.pop(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),

                height: 40,
                width: 70,
                child: Center(
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _per = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter += 0.1;
  //     _per = 10 + _per;
  //     if (_per > 100) _per = 100;
  //   });
  // }

  void Decrement() {
    setState(() {
      _counter = _counter - 0.1;
      _per = _per - 10;
    });
  }

  final now = DateTime.now();
  final day = DateFormat('EEEE').format(DateTime.now()); // e.g., Friday
  final date = DateFormat('MMM d').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF7FF),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              "assets/images/app_drop.png", // your image path
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$day, $date',
                  style: TextStyle(fontSize: 16, color: Color(0xffFFFFFF)),
                ),
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),

        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[


                SizedBox(
                  width: 150,
                  height: 300,
                  child:LiquidCustomProgressIndicator(
                    value: _counter,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    backgroundColor: const Color(0xff9ED1FF),
                    direction: Axis.vertical,
                    center: Text(
                      '${(_counter * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    shapePath: _buildWaterDropPath(Size(150, 200)),
                  )

                ),
                TextButton(onPressed: Decrement, child: Text('zero')),

                Container(
                  width: 290,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text( "${((todayDrank / dailyGoal) * 100).clamp(0, 100).toInt()}%", style: TextStyle()),
                          Text('$dailyGoal'+'ml', style: TextStyle()),
                        ],
                      ),
                      LinearPercentIndicator(
                        width: 290,

                        animation: false,
                        lineHeight: 15.0,
                        animationDuration: 2000,
                        percent: _counter,
                        padding: EdgeInsets.all(0.0),
                        barRadius: Radius.circular(5),
                        backgroundColor: const Color(0xff9ED1FF),
                        progressColor: Colors.blue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress', style: TextStyle()),
                          Text('Daily goal', style: TextStyle()),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: (){_addDrink(selectedMl,selectedImage);},
                        child: Container(
                          height: 54,
                          width: 290,

                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                  0.5,
                                ), // Shadow color
                                spreadRadius: 2, // How much it spreads
                                blurRadius: 8, // How blurry it looks
                                offset: Offset(4, 4), // X and Y offset
                              ),
                            ],
                            border: Border.all(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.blue, size: 35),
                                Mytext(
                                  txt: 'DRINK',
                                  color: Colors.blue,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 40,
                                child: Image.asset(
                                  height: 60,
                                  width: 50,
                                  fit: BoxFit.fill,
                                  selectedImage,
                                ),
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      DatabaseHelper.instance.debugPrintAllData();
                                    },
                                    child: Text("Print All DB Data"),
                                  ),

                                  Text(
                                    'Water',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('$selectedMl'),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _showDrinkSelector,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                color: Color(0xff278DE8),
                              ),
                              width: 86,
                              height: 31,
                              child: Center(
                                child: Mytext(
                                  txt: "Edit",
                                  size: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// This path looks like a real teardrop shape
// Path _buildWaterDropPath(Size size) {
//   final double width = size.width;
//   final double height = size.height;
//
//   final Path path = Path();
//   path.moveTo(width * 0.5, 0);
//   path.cubicTo(
//     width * 0.9,
//     height * 0.3,
//     width * 0.9,
//     height * 0.7,
//     width * 0.5,
//     height,
//   );
//   path.cubicTo(
//     width * 0.1,
//     height * 0.7,
//     width * 0.1,
//     height * 0.3,
//     width * 0.5,
//     0,
//   );
//   path.close();
//   return path;
// }
Path _buildWaterDropPath(Size size) {
  final path = Path();
  final width = size.width;
  final height = size.height;

  path.moveTo(width / 2, 0); // top middle point
  path.quadraticBezierTo(width, height * 0.35, width / 2, height);
  path.quadraticBezierTo(0, height * 0.35, width / 2, 0);
  path.close();

  return path;
}
