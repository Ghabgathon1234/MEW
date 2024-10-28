import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import for localization

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about'.tr()), // Localized title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'about_description'.tr(), // Localized description
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                    height: 1.4,
                    color: Color(0xff1d1b20),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'about_contact'.tr(), // Localized contact information
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                    height: 1.4,
                    color: Color(0xff1d1b20),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'about_copyright'.tr(), // Localized copyright
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                    height: 1.4,
                    color: Color(0xff1d1b20),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
