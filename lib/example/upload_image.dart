import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CloudinaryUploadPage extends StatefulWidget {
  const CloudinaryUploadPage({super.key});

  @override
  _CloudinaryUploadPageState createState() => _CloudinaryUploadPageState();
}

class _CloudinaryUploadPageState extends State<CloudinaryUploadPage> {
  File? _image;
  String? _uploadedImageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    String cloudinaryUrl =
        'https://api.cloudinary.com/v1_1/dcw8dvlqo/image/upload';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = 'userURL' // Preset නම
        ..fields['folder'] = 'users' // Folder නම
        ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        setState(() {
          _uploadedImageUrl = jsonResponse['secure_url']; // Uploaded Image URL
        });

        print('Image uploaded: $_uploadedImageUrl');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload to Cloudinary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
            if (_uploadedImageUrl != null)
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text('Uploaded Image:'),
                  Image.network(
                    _uploadedImageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
