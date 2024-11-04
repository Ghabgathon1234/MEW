import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../database_helper.dart';

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
    'Training Course',
    'OFF (before/after training)',
    'Remove Vacation'
  ];

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

  Future<void> _saveVacation() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    for (DateTime date = _startDate;
        !date.isAfter(_endDate);
        date = date.add(const Duration(days: 1))) {
      DayRecord? existingRecord =
          await dbHelper.getDayRecord(date.year, date.month, date.day);

      if (existingRecord != null) {
        String status = _selectedVacationType == 'Remove Vacation'
            ? 'onDuty'
            : _selectedVacationType;

        if (status == 'Training Course') {
          DayRecord updatedRecord = DayRecord(
            year: existingRecord.year,
            month: existingRecord.month,
            day: existingRecord.day,
            status: status,
            shift: status,
            attend1: status == 'onDuty' ? existingRecord.attend1 : null,
            attend2: status == 'onDuty' ? existingRecord.attend2 : null,
            attend3: status == 'onDuty' ? existingRecord.attend3 : null,
            leave1: status == 'onDuty' ? existingRecord.leave1 : null,
            leave2: status == 'onDuty' ? existingRecord.leave2 : null,
            delayMinutes: status == 'onDuty' ? existingRecord.delayMinutes : 0,
          );
          await dbHelper.insertOrUpdateDayRecord(updatedRecord);
        } else {
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
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('vacation is updated'.tr())), // Using tr() for translation
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vacations'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3B5BDB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Add/Remove Vacations'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5BDB),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Vacation Type Card
            _buildCard(
              child: Column(
                children: [
                  Text(
                    'Vacation Type'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedVacationType,
                    items: _vacationTypes.map((String vacationType) {
                      return DropdownMenuItem<String>(
                        value: vacationType,
                        child: Text(vacationType.tr()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedVacationType = newValue!;
                      });
                    },
                    isExpanded: true,
                    //dropdownColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Start Date Picker Card
            _buildCard(
              child: _buildDatePicker(
                title: 'start date'.tr(),
                date: _startDate,
                onPressed: () => _selectStartDate(context),
              ),
            ),
            const SizedBox(height: 20),

            // End Date Picker Card
            _buildCard(
              child: _buildDatePicker(
                title: 'end date'.tr(),
                date: _endDate,
                onPressed: () => _selectEndDate(context),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveVacation,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Color(0xFF3B5BDB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to create a card
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  // Helper widget to create a date picker row
  Widget _buildDatePicker({
    required String title,
    required DateTime date,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
          ),
          child: Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
