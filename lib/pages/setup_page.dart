// lib/pages/setup_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation.dart'; // Import MainNavigation
import 'package:easy_localization/easy_localization.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String? _selectedTeam;
  String? _selectedLocation;
  String _selectedLanguage = 'en'; // Default language is English

  // Define available teams, locations, and languages
  final List<String> _teams = ['A', 'B', 'C', 'D'];
  final List<String> _locations = [
    'Alsabbiyah Powerplant',
    'East Doha Powerplant',
    'West Doha Powerplant',
    'Alshuwaikh Powerplant',
    'Shuaibah Powerplant',
    'Alzour Powerplant',
  ];
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'ar', 'label': 'Arabic'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load the saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTeam = prefs.getString('team') ?? _teams.first;
      _selectedLocation = prefs.getString('location') ?? _locations.first;
      _selectedLanguage = prefs.getString('language') ?? 'en'; // Load language
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
        SnackBar(content: Text(tr('settings_saved_successfully'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('please_select_team_location'))),
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
        title: Text(tr('Setup Page')), // Localized title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Team selection dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: tr('Select Team'), // Localized label
                border: const OutlineInputBorder(),
              ),
              value: _selectedTeam,
              items: _teams.map((team) {
                return DropdownMenuItem(
                  value: team,
                  child: Text('${tr('team')} $team'), // Localized text
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam = value;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Location selection dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: tr('select_location'), // Localized label
                border: const OutlineInputBorder(),
              ),
              value: _selectedLocation,
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(tr(location)), // Location is not localized
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 32.0),

            // Language selection dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: tr('Change Language'), // Localized label
                border: const OutlineInputBorder(),
              ),
              value: _selectedLanguage,
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language['code'],
                  child: Text(tr(language['label']!)), // Display language name
                );
              }).toList(),
              onChanged: (value) {
                _changeLanguage(value!);
              },
            ),
            const SizedBox(height: 32.0),

            // Complete setup button
            ElevatedButton(
              onPressed: _selectedTeam != null && _selectedLocation != null
                  ? _completeSetup
                  : null,
              child: Text(tr('Save Settings')), // Localized button text
            ),
          ],
        ),
      ),
    );
  }

  // Complete the setup by saving the data and navigating to the main screen
  Future<void> _completeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('team', _selectedTeam!);
    await prefs.setString('location', _selectedLocation!);
    await prefs.setBool('hasLaunched', true); // Mark setup as completed

    // Navigate to MainNavigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainNavigation()),
    );
  }
}
