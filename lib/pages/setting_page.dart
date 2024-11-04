import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? _selectedTeam;
  String? _selectedLocation;
  String _selectedLanguage = 'en';

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

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTeam = prefs.getString('team') ?? _teams.first;
      _selectedLocation = prefs.getString('location') ?? _locations.first;
      _selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTeam != null && _selectedLocation != null) {
      await prefs.setString('team', _selectedTeam!);
      await prefs.setString('location', _selectedLocation!);
      await prefs.setString('language', _selectedLanguage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Settings saved successfully!').tr()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both team and location.').tr()),
      );
    }
  }

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
        title: Text(
          'Settings'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B5BDB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'App Settings'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5BDB),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Card for all dropdowns
            _buildCard(
              child: Column(
                children: [
                  // Team Selection
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Team'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    value: _selectedTeam ?? _teams.first,
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

                  // Location Selection
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Location'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    value: _selectedLocation ?? _locations.first,
                    items: _locations.map((location) {
                      String translatedLocation =
                          _getTranslatedLocation(location);
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

                  // Language Selection
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Change Language'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    value: _selectedLanguage,
                    items: _languages.map((language) {
                      return DropdownMenuItem(
                        value: language['code'],
                        child: Text(tr(language['label']!)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _changeLanguage(value!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: const Color(0xFF3B5BDB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Settings'.tr(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
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

  // Helper method for translated location names
  String _getTranslatedLocation(String location) {
    switch (location) {
      case 'Alsabbiyah Powerplant':
        return 'alsabbiyah'.tr();
      case 'East Doha Powerplant':
        return 'east_doha'.tr();
      case 'West Doha Powerplant':
        return 'west_doha'.tr();
      case 'Alshuwaikh Powerplant':
        return 'alshuwaikh'.tr();
      case 'Shuaibah Powerplant':
        return 'shuaibah'.tr();
      case 'Alzour Powerplant':
        return 'alzour'.tr();
      default:
        return location.tr();
    }
  }
}
