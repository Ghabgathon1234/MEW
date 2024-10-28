import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart'; // For localization support

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? _selectedTeam;
  String? _selectedLocation;
  String _selectedLanguage = 'en'; // Default language is English

  // Define your teams and locations here.
  // Ensure that each location is unique.
  final List<String> _teams = ['A', 'B', 'C', 'D'];
  final List<String> _locations = [
    'Alsabbiyah Powerplant',
    'East Doha Powerplant',
    'West Doha Powerplant',
    'Alshuwaikh Powerplant',
    'Shuaibah Powerplant',
    'Alzour Powerplant', // Ensure this is only listed once
  ];

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'ar', 'label': 'Arabic'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load stored settings when page is initialized
  }

  // Load current settings from SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTeam =
          prefs.getString('team') ?? _teams.first; // Default to first team
      _selectedLocation = prefs.getString('location') ??
          _locations.first; // Default to first location
      _selectedLanguage =
          prefs.getString('language') ?? 'en'; // Default to English
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTeam != null && _selectedLocation != null) {
      await prefs.setString('team', _selectedTeam!);
      await prefs.setString('location', _selectedLocation!);
      await prefs.setString('language', _selectedLanguage); // Save language

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Settings saved successfully!')
                .tr()), // Localized success message
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select both team and location.')
                .tr()), // Localized error message
      );
    }
  }

  // Change app language
  void _changeLanguage(String languageCode) {
    if (languageCode == 'ar') {
      context.setLocale(const Locale('ar', 'AR'));
    } else {
      context.setLocale(const Locale('en', 'US'));
    }
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Settings')), // Localized title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Team Selection Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Team'.tr(), // Localized label
                border: const OutlineInputBorder(),
              ),
              value: _selectedTeam ??
                  _teams.first, // Ensure a default value is set
              items: _teams.map((team) {
                return DropdownMenuItem(
                  value: team,
                  child: Text(tr('Team $team')),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Location Selection Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Location'.tr(), // Localized label
                border: const OutlineInputBorder(),
              ),
              value: _selectedLocation ??
                  _locations.first, // Ensure a default value is set
              items: _locations.map((location) {
                // Match the hardcoded location with the key used in your JSON files
                String translatedLocation = '';
                switch (location) {
                  case 'Alsabbiyah Powerplant':
                    translatedLocation = 'alsabbiyah'.tr();
                    break;
                  case 'East Doha Powerplant':
                    translatedLocation = 'east_doha'.tr();
                    break;
                  case 'West Doha Powerplant':
                    translatedLocation = 'west_doha'.tr();
                    break;
                  case 'Alshuwaikh Powerplant':
                    translatedLocation = 'alshuwaikh'.tr();
                    break;
                  case 'Shuaibah Powerplant':
                    translatedLocation = 'shuaibah'.tr();
                    break;
                  case 'Alzour Powerplant':
                    translatedLocation = 'alzour'.tr();
                    break;
                }
                return DropdownMenuItem(
                  value: location,
                  child: Text(translatedLocation),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Language change dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Change Language'.tr(), // Localized label
                border: const OutlineInputBorder(),
              ),
              value: _selectedLanguage, // Ensure a default value is set
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language['code'],
                  child: Text(tr(language['label']!)), // Display language name
                );
              }).toList(),
              onChanged: (value) {
                _changeLanguage(value!); // Change app language
              },
            ),
            const SizedBox(height: 30),

            // Save Button, moved below the language picker
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
              ),
              child: Text('Save Settings').tr(), // Localized button text
            ),
          ],
        ),
      ),
    );
  }
}
