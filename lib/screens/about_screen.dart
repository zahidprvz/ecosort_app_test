import 'package:ecosort_app_test/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '20021519-117@uog.edu.pk',
      queryParameters: {'subject': 'App Feedback/Issue'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/zulfiqar-profile.jpeg'),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Muhammad Zulfiqar Younas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Roll No: 20021519-117',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                'About Me',
                secondaryColor,
              ),
              const SizedBox(height: 10),
              const Text(
                'I am a final year student passionate about AI and App development, focused on Flutter and Deep Learning.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                'About the App',
                secondaryColor,
              ),
              const SizedBox(height: 10),
              const Text(
                'This app is my final year project. It utilizes a TensorFlow Lite model to classify images of garbage into various categories, providing users with relevant disposal suggestions. '
                'The app is built using Flutter and Dart, with Firebase integration for data storage.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Disclaimer', Colors.red),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                  children: [
                    const TextSpan(
                        text:
                            'By using this app, you agree to send us the app usage data, which may be used in the future to improve the AI model and enhance Flutter. '),
                    const TextSpan(
                      text:
                          'In case of any issues or to report a problem with the app, you can email me at: ',
                    ),
                    TextSpan(
                      text: '20021519-117@uog.edu.pk',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = _launchEmail,
                    ),
                    const TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color? color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
