import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Add easy localization
import '../database_helper.dart'; // Adjust the import path as needed

class VacationsPage extends StatefulWidget {
  const VacationsPage({super.key});

  @override
  _VacationsPageState createState() => _VacationsPageState();
}

class _VacationsPageState extends State<VacationsPage> {
  String _selectedVacationType = 'Sick Leave';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final List<String> _vacationTypes = [
    'Sick Leave',
    'Vacation',
    'Casual Leave',
    'Remove Vacation'
  ];

  // Function to select the start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  // Function to select the end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  // Function to save vacation details to the database
  Future<void> _saveVacation() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    for (DateTime date = _startDate;
        !date.isAfter(_endDate);
        date = date.add(const Duration(days: 1))) {
      // Retrieve existing day record
      DayRecord? existingRecord =
          await dbHelper.getDayRecord(date.year, date.month, date.day);

      if (existingRecord != null) {
        // Set status based on vacation type
        String status = _selectedVacationType == 'Remove Vacation'
            ? 'onDuty'
            : _selectedVacationType;

        // Update the day record status
        DayRecord updatedRecord = DayRecord(
          year: existingRecord.year,
          month: existingRecord.month,
          day: existingRecord.day,
          status: status,
          shift: existingRecord.shift,
          attend1: status == 'onDuty' ? existingRecord.attend1 : null,
          attend2: status == 'onDuty' ? existingRecord.attend2 : null,
          attend3: status == 'onDuty' ? existingRecord.attend3 : null,
          leave1: status == 'onDuty' ? existingRecord.leave1 : null,
          leave2: status == 'onDuty' ? existingRecord.leave2 : null,
          delayMinutes: status == 'onDuty' ? existingRecord.delayMinutes : 0,
        );

        await dbHelper.insertOrUpdateDayRecord(updatedRecord);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('vacation_updated'.tr())), // Using tr() for translation
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacations'.tr()), // Using tr() for translation
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Title
            Center(
              child: Text(
                'Add/Remove Vacations'.tr(), // Using tr() for translation
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Second Row: Vacation Type Picker
            Center(
              child: DropdownButton<String>(
                value: _selectedVacationType,
                items: _vacationTypes.map((String vacationType) {
                  return DropdownMenuItem<String>(
                    value: vacationType,
                    child: Text(vacationType.tr()), // Translate vacation types
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVacationType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Third Row: Start Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'start date:'.tr(), // Using tr() for translation
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fourth Row: End Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'end date:'.tr(), // Using tr() for translation
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(_endDate)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Fifth Row: Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveVacation,
                child: Text('Save'.tr()), // Using tr() for translation
              ),
            ),
          ],
        ),
      ),
    );
  }
}
