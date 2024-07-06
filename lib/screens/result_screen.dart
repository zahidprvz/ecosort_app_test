import 'dart:convert';
import 'dart:io';
import 'package:ecosort_app_test/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import '../services/firebase_service.dart';

class ResultScreen extends StatefulWidget {
  final File imageFile;

  const ResultScreen({super.key, required this.imageFile});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  tfl.Interpreter? _interpreter;
  List<String> _labels = [];
  String _result = '';
  bool _processing = false;
  bool _buttonDisabled = false;
  bool _loading = false;
  final String _uploadStatus = '';

  final Map<String, String> _descriptions = {
    'battery':
        'Batteries contain chemicals and metals that are hazardous. They should be disposed of at designated collection points for recycling.',
    'biological':
        'Biological waste includes food scraps and other organic materials. It can be composted to create nutrient-rich soil.',
    'brown-glass':
        'Brown glass is typically used for beer and certain other beverages. It can be recycled multiple times without losing quality.',
    'cardboard':
        'Cardboard can be recycled into new paper products. Ensure it is clean and dry before recycling.',
    'clothes':
        'Old clothes can be donated, repurposed, or recycled into textile fibers.',
    'green-glass':
        'Green glass is often used for wine bottles. Like brown glass, it can be recycled indefinitely.',
    'metal':
        'Metal items like cans can be recycled into new metal products. Ensure they are clean before recycling.',
    'paper':
        'Paper can be recycled into new paper products. Avoid recycling contaminated or greasy paper.',
    'plastic':
        'Plastics come in various types. Check local recycling guidelines to determine which plastics can be recycled.',
    'shoes':
        'Old shoes can often be donated or repurposed. Some brands offer recycling programs.',
    'trash':
        'Trash refers to items that cannot be recycled or composted. These should be disposed of in the trash bin.',
    'white-glass':
        'White (clear) glass is used for beverages and food jars. It can be recycled multiple times without losing quality.',
  };

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadModel();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset(
          'assets/garbage_classification_model.tflite');
      if (kDebugMode) {
        print('Model loaded successfully');
      }
      _loadLabels();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load the model: $e');
      }
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labels = await rootBundle.loadString('assets/labels.txt');
      _labels = LineSplitter.split(labels).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load labels: $e');
      }
    }
  }

  Future<bool> _classifyImage(File image) async {
    setState(() {
      _loading = true;
      _buttonDisabled = true;
      //_uploadStatus = 'Wait before the data is sent to Firebase database';
    });

    if (_interpreter == null) {
      if (kDebugMode) {
        print('Interpreter not initialized');
      }
      return false;
    }

    // Existing code for image classification...
    var imageBytes = await image.readAsBytes();
    img.Image? imageAsImage = img.decodeImage(imageBytes);

    var inputImage = img.copyResize(imageAsImage!, width: 224, height: 224);

    var inputAsList = List<double>.empty(growable: true);

    for (int y = 0; y < inputImage.height; y++) {
      for (int x = 0; x < inputImage.width; x++) {
        var pixel = inputImage.getPixel(x, y);
        var red = pixel.r / 255.0;
        var green = pixel.g / 255.0;
        var blue = pixel.b / 255.0;

        inputAsList.add(red);
        inputAsList.add(green);
        inputAsList.add(blue);
      }
    }

    var inputTensor =
        Float32List.fromList(inputAsList).reshape([1, 224, 224, 3]);

    var output =
        List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);

    _interpreter!.run(inputTensor, output);

    var maxIndex = output[0].indexOf(
        output[0].reduce((a, b) => (a as double) > (b as double) ? a : b));

    setState(() {
      _processing = false;
      _result = _labels[maxIndex];
      _buttonDisabled = false;
    });

    // Store the image and its result in Firebase
    FirebaseService firebaseService = FirebaseService();
    bool success =
        await firebaseService.storeImageResult(widget.imageFile, _result);

    setState(() {
      _loading = false;
      //_uploadStatus = success? 'Data stored successfully.': 'Failed to store data. Please check your internet connection.';
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data sent to Database successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to store data. Please check your internet connection.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.file(
                  widget.imageFile,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                if (_loading)
                  Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                if (_uploadStatus.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    child: Text(
                      _uploadStatus,
                      style: TextStyle(
                        fontSize: 16,
                        color: _uploadStatus.startsWith('Failed')
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buttonDisabled
                  ? null
                  : () async {
                      await _classifyImage(widget.imageFile);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonDisabled
                    ? Colors.grey
                    : Theme.of(context).colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: Text(
                _processing ? 'Processing...' : 'Process Image',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Classified as: $_result',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _descriptions[_result] ?? 'No description available.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: mobileBackgroundColor,
    );
  }
}
