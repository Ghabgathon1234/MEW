import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'about'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B5BDB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 70.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App description
                Text(
                  'about_description'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    height: 1.5,
                    color: Color(0xff1d1b20),
                  ),
                ),
                const SizedBox(height: 20),

                // Decorative line separator
                Divider(color: Colors.grey.shade300, thickness: 1.2),
                const SizedBox(height: 20),

                // Contact information
                Text(
                  'about_contact'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    height: 1.5,
                    color: Color(0xff1d1b20),
                  ),
                ),
                const SizedBox(height: 20),

                // Decorative line separator
                Divider(color: Colors.grey.shade300, thickness: 1.2),
                const SizedBox(height: 20),

                // Copyright information
                Text(
                  'about_copyright'.tr(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
