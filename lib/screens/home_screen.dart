import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

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
      backgroundColor: Color(0xffE4E4E4),
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
                shapePath: _buildRealWaterDropPath(),
              ),
            ),
                TextButton(onPressed: Decrement, child: Text('zero')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// This path looks like a real teardrop shape
Path _buildRealWaterDropPath() {
  final Path path = Path();

  path.moveTo(60, 0); // Start at top center
  path.cubicTo(110, 30, 120, 100, 60, 180); // Right curve
  path.cubicTo(0, 10, 10, 30, 60, 0); // Left curve

  path.close(); // Close the path
  return path;
}