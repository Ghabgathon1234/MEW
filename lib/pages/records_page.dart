import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import for localization
import '../database_helper.dart'; // Adjust the import path as needed

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<YearRecord> _yearRecords = [];
  Map<int, List<MonthRecord>> _monthRecords = {};

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  // Fetch the year and month records from the database
  Future<void> _fetchRecords() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Fetch all year records
    List<Map<String, dynamic>> yearRecordsMap =
        await dbHelper.getAllYearRecords();
    List<YearRecord> yearRecords =
        yearRecordsMap.map((e) => YearRecord.fromMap(e)).toList();

    // Fetch month records for each year
    Map<int, List<MonthRecord>> monthRecords = {};
    for (var yearRecord in yearRecords) {
      int year = yearRecord.year;
      List<Map<String, dynamic>> monthsMap =
          await dbHelper.getMonthRecordsForYear(year);
      List<MonthRecord> months =
          monthsMap.map((e) => MonthRecord.fromMap(e)).toList();
      monthRecords[year] = months;
    }

    setState(() {
      _yearRecords = yearRecords;
      _monthRecords = monthRecords;
    });
  }

  // Format delay minutes as hh:mm
  String _formatDelay(int delayMinutes) {
    int hours = delayMinutes ~/ 60;
    int minutes = delayMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('records'.tr()), // Using tr() for localization
      ),
      body: _yearRecords.isEmpty
          ? Center(
              child: Text(
                'no_records_found'.tr(), // Using tr() for localization
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _yearRecords.length,
              itemBuilder: (context, index) {
                YearRecord yearRecord = _yearRecords[index];
                int year = yearRecord.year;
                int workedDays = yearRecord.workedDays;
                int delayMinutes = yearRecord.delay;
                String formattedDelay = _formatDelay(delayMinutes);

                // Get the list of month records for this year
                List<MonthRecord> months = _monthRecords[year] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Year record section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${'year'.tr()}: $year | ${'delay'.tr()}: $formattedDelay | ${'worked_days'.tr()}: $workedDays', // Using tr() for localization
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 12 rows for months with delay minutes
                    Column(
                      children: months.map((monthRecord) {
                        String monthName = getMonthName(monthRecord.month)
                            .tr(); // Localized month names
                        int monthDelay = monthRecord.monthlyDelay;
                        String formattedMonthDelay = _formatDelay(monthDelay);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(monthName),
                              Text('${'delay'.tr()}: $formattedMonthDelay'),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(thickness: 2), // Divider between years
                  ],
                );
              },
            ),
    );
  }

  String getMonthName(int month) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
