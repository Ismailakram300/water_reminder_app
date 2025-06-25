import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:water_reminder_app/customs_widgets/mytext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _counter = 0.1;
  int _per = 0;

  void _incrementCounter() {
    setState(() {
      _counter += 0.1;
      _per = 10 + _per;
      if (_per > 100) _per = 100;
    });
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
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
                  width: 120,
                  height: 180,
                  child: LiquidCustomProgressIndicator(
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
                  ),
                ),
                TextButton(onPressed: Decrement, child: Text('zero')),

                Container(
                  width: 320,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$_per%', style: TextStyle()),
                          Text('258ml', style: TextStyle()),
                        ],
                      ),
                      LinearPercentIndicator(
                        width: 320,

                        animation: true,
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
                        onTap: _incrementCounter,
                        child: Container(
                          height: 75,
                          width: 320,

                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // Shadow color
                                spreadRadius: 2,   // How much it spreads
                                blurRadius: 8,     // How blurry it looks
                                offset: Offset(4, 4), // X and Y offset
                              ),
                            ],
                            border: Border.all(color: Color(0xff585858), width: 1.5),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.blue, size: 40),
                                Mytext(txt: 'DRINK', color: Colors.blue),
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
                                  'assets/images/glass-water.png',
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Water',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('100ml'),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
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
Path _buildWaterDropPath(Size size) {
  final double w = size.width;
  final double h = size.height;

  final Path path = Path();
  path.moveTo(w * 0.5, 0);
  path.quadraticBezierTo(w * 0.95, h * 0.35, w * 0.5, h);
  path.quadraticBezierTo(w * 0.05, h * 0.35, w * 0.5, 0);
  path.close();
  return path;
}


