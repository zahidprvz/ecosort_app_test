import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Help',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This app helps you classify waste materials into different categories. Follow the steps below to use the app:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildStep(
              context,
              icon: Icons.camera_alt,
              text: 'Take a photo of your waste item.',
            ),
            const SizedBox(height: 15),
            _buildStep(
              context,
              icon: Icons.photo_library,
              text: 'Choose an image from your gallery.',
            ),
            const SizedBox(height: 20),
            const Text(
              'The app will then analyze the image and provide you with the classification into one of the 12 categories.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            _buildCategoriesList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 40, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    final categories = [
      'battery',
      'biological',
      'brown-glass',
      'cardboard',
      'clothes',
      'green-glass',
      'metal',
      'paper',
      'plastic',
      'shoes',
      'trash',
      'white-glass',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Waste Categories:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...categories.map((category) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8),
              const SizedBox(width: 8),
              Text(category, style: const TextStyle(fontSize: 16)),
            ],
          ),
        )),
      ],
    );
  }
}
