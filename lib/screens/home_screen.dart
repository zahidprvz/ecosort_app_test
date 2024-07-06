import 'dart:io';
import 'package:ecosort_app_test/screens/about_screen.dart';
import 'package:ecosort_app_test/screens/login_screen.dart';
import 'package:ecosort_app_test/services/auth_methods.dart';
import 'package:ecosort_app_test/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'result_screen.dart';
import '../components/help_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        foregroundColor: Colors.white,
        title: const Text('Waste Classification'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            color: secondaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 20),
                _buildImageOptions(context, buttonStyle),
                const SizedBox(height: 20),
                _buildHelpButton(context, buttonStyle),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () async {
                  await AuthMethods().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Exit'),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: mobileBackgroundColor,
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      borderOnForeground: true,
      semanticContainer: true,
      surfaceTintColor: Colors.yellowAccent,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Welcome to EcoSort!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'EcoSort helps you classify waste materials into different categories easily and efficiently. Simply take a photo or choose an image to get started.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOptions(BuildContext context, ButtonStyle buttonStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _captureImage(context);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
            style: buttonStyle,
          ),
        ),
        const SizedBox(width: 10), // Add a slight width between the buttons
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _pickImageFromGallery(context);
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose Image'),
            style: buttonStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpButton(BuildContext context, ButtonStyle buttonStyle) {
    return SizedBox(
      height: 60, // Define a fixed height
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const HelpDialog(),
          );
        },
        style: buttonStyle,
        child: const Text(
          'Help',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imageFile: File(pickedImage.path)),
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imageFile: File(pickedImage.path)),
        ),
      );
    }
  }
}
