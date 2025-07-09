import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:numberpicker/numberpicker.dart';
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

  String selectedImage =
      'assets/images/water_100ml/water_100ml.png'; // default image
  int selectedMl = 100;
  int dailyGoal = 250;
  int todayDrank = 0;
  double _counter = 0.0;
  int percentage = 0;
  Future<void> _loadImageFromDatabase() async {
    final data = await DatabaseHelper.instance.getUserData();
    if (data != null) {
      print(
        "Loaded from DB: ${data['selectedImage']} | ml: ${data['selectedMl']} | dailyGoal: ${data['dailyGoal']}",
      ); // Debug log
      setState(() {
        selectedImage =
            data['selectedImage'] ??
            'assets/images/water_100ml/water_100ml.png';
        selectedMl = data['selectedMl'] ?? 100;
        dailyGoal = data['dailyGoal'] ?? 250;
      });
    }
  }

  Future<bool> showDailyGoalDialog(
    BuildContext context,
    int initialValue,
  ) async {
    int currentValue = initialValue;
    bool isSaved = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xffE4E4E4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Daily Goal",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Mulish'),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                    value: currentValue,
                    minValue: 100,
                    decoration: BoxDecoration(),
                    maxValue: 10000,
                    step: 50,
                    haptics: true,
                    onChanged: (value) => setState(() => currentValue = value),
                    selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 28,
                    ),
                    textStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  Text(
                    "ml",

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff278DE8),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        style: TextStyle(
                          color: Color(0xff7A7A7A),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.updateDailyGoal(currentValue);
                    await DatabaseHelper.instance.debugPrintAllUserData();
                    Navigator.of(context).pop();
                    isSaved = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Daily goal set to $currentValue ml"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
    return isSaved;
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
                    style: TextStyle(
                      color: Color(0xff7A7A7A),
                      fontWeight: FontWeight.bold,
                    ),
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

  final now = DateTime.now();
  final day = DateFormat('EEEE').format(DateTime.now()); // e.g., Friday
  final date = DateFormat('MMM d').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffEFF7FF),
       // extendBodyBehindAppBar: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset(
                "assets/images/app_drop/app_drop.png", // your image path
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Mulish',
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          backgroundColor: Color(0xff278DE8),
        ),

        body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: LiquidCustomProgressIndicator(
                      value: _counter,
                      valueColor: AlwaysStoppedAnimation(Color(0xff4EA0E9)),
                      backgroundColor: const Color(0xff9ED1FF),
                      direction: Axis.vertical,
                      center: Text(
                        '${(_counter * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',

                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      shapePath: _buildWaterDropPath(),
                    ),
                  ),

                  Container(
                    width: 290,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${((todayDrank / dailyGoal) * 100).clamp(0, 100).toInt()}%",
                              style: TextStyle(fontFamily: 'Mulish'),
                            ),
                            Text(
                              '$dailyGoal' + 'ml',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0xff3E3E3E),
                              ),
                            ),
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
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0xff3E3E3E),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                              child: InkWell(
                                onTap: () async {
                                  final userData = await DatabaseHelper.instance
                                      .getUserData();
                                  final currentGoal =
                                      userData?['dailyGoal'] ?? 2000;
                                  final update = await showDailyGoalDialog(
                                    context,
                                    currentGoal,
                                  );
                                  if (update) {
                                    await _loadProgress();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xff278DE8),
                                  ),
                                  width: 75,
                                  height: 27,
                                  child: Center(
                                    child: Mytext(
                                      txt: "Daily Goal",
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _addDrink(selectedMl, selectedImage);
                          },
                          child: Container(
                            height: 54,
                            width: 290,

                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                    0.3,
                                  ), // Shadow color
                                  spreadRadius: 2, // How much it spreads
                                  blurRadius: 8, // How blurry it looks
                                  offset: Offset(4, 4), // X and Y offset
                                ),
                              ],
                              //border: Border.all(color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0xff278DE8),
                                    size: 35,
                                  ),
                                  Mytext(
                                    txt: 'DRINK',
                                    color: Color(0xff278DE8),
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
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Water',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',

                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('$selectedMl' + 'ml'),
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
      ),
    );
  }
}

/// This path looks like a real teardrop shape
Path _buildWaterDropPath() {
  final path = Path();

  // Start at the bottom center
  path.moveTo(150, 300);

  // Right side curve
  path.cubicTo(
    260,
    230, // Control point 1 (right)
    260,
    100, // Control point 2 (top right curve)
    150,
    0, // End at top point
  );

  // Left side curve
  path.cubicTo(
    40,
    100, // Control point 1 (top left curve)
    40,
    230, // Control point 2 (left)
    150,
    300, // Back to bottom center
  );

  path.close();
  return path;
}
