import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/database_helper.dart';
import '../Models/drinks_log.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map<String, int> dailyTotals = {};

  @override
  void initState() {
    super.initState();
    _calculateDailyTotals();
  }

  Future<void> _generateAndPrintPdf() async {
    final pdfDoc = pw.Document();

    final sortedDates = dailyTotals.keys.toList()..sort((a, b) => b.compareTo(a));

    pdfDoc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Water Intake Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...sortedDates.map((dateKey) {
              final formattedDate = DateFormat('MMM d, yyyy').format(DateTime.parse(dateKey));
              final total = dailyTotals[dateKey]!;
              return pw.Text('$formattedDate - $total ml', style: pw.TextStyle(fontSize: 16));
            }).toList(),
          ],
        ),
      ),
    );

    // Preview or Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfDoc.save(),
    );
  }


  Future<void> _calculateDailyTotals() async {
    final allLogs = await DatabaseHelper.instance.getAllLogs();

    // Group by date
    final Map<String, int> totals = {};
    for (var log in allLogs) {
      final dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);
      totals[dateKey] = (totals[dateKey] ?? 0) + log.amount;
    }

    setState(() {
      dailyTotals = totals;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates = dailyTotals.keys.toList()..sort((a, b) => b.compareTo(a)); // Newest first

    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          _generateAndPrintPdf();
        },
        icon: Icon(Icons.picture_as_pdf),
        label: Text("Export PDF"),
      ),

      backgroundColor: Color(0xffE4E4E4),
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 👈 back to previous screen
          },
        ),
        title: Text('Daily Drink Totals',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Mulish',

        ),),
        backgroundColor: Colors.blue,
      ),

      body: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          final dateKey = sortedDates[index];
          final total = dailyTotals[dateKey]!;
          final formattedDate = DateFormat('MMM d, yyyy').format(DateTime.parse(dateKey));
 return Padding(
   padding: const EdgeInsets.all(8.0),
   child: Card(
              color: Color(0xffEFF7FF),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.blue),
                title: Text('Total Drank: $total ml',style: TextStyle(
                  fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                ),),
                subtitle:Text('${formattedDate} ml') ,
              ),
            ),
 );
          // return ListTile(
            //leading: Icon(Icons.calendar_today, color: Colors.blue),
          //   title: Text(formattedDate),
          //   trailing: Text('$total ml'),
          // );
        },
      ),
    );
  }
}
