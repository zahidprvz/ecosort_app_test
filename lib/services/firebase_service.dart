import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> storeImageResult(File imageFile, String result) async {
    try {
      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      // Create a unique folder name for the session
      String folderName = DateTime.now().millisecondsSinceEpoch.toString();

      // Get a reference to the storage bucket location
      Reference storageRef = _storage.ref().child('sessions/$folderName');

      // Upload the image file to Firebase Storage
      String imageName = 'image.jpg';
      Reference imageRef = storageRef.child(imageName);
      await imageRef.putFile(imageFile);

      // Get the download URL of the uploaded image
      String imageUrl = await imageRef.getDownloadURL();

      // Store result and description in a text file
      String resultFileName = 'result.txt';
      Reference resultRef = storageRef.child(resultFileName);
      String resultContent =
          'Result: $result\n\nDescription: ${_descriptions[result]}';
      await resultRef.putString(resultContent);

      // Store session details in the database
      DatabaseReference sessionsRef = _database.child('sessions');
      String? key = sessionsRef.push().key;
      await sessionsRef.child(key!).set({
        'imageUrl': imageUrl,
        'result': result,
        'description': _descriptions[result],
      });

      print('Image and result stored successfully.');
    } catch (e) {
      print('Error storing image and result: $e');
    }
  }

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
}
