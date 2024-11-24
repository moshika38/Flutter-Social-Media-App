import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart'; // For loading assets
import 'dart:typed_data'; // For Uint8List

class UploadImageButton extends StatelessWidget {
  const UploadImageButton({super.key});

  Future<void> _uploadImage() async {
    try {
      // Load image from assets
      final ByteData data = await rootBundle.load('assets/images/post.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('uploads/post.jpg');

      // Upload the image
      final uploadTask = imageRef.putData(bytes);

      // Monitor upload progress or completion
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        print('Upload is ${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes * 100}% complete');
      });

      await uploadTask;
      print('Image uploaded successfully!');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _uploadImage,
          child: const Text('Upload Image'),
        ),
      ),
    );
  }
}
