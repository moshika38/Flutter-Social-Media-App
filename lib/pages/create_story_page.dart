import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app_flutter/providers/user_provider.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  bool hasStory = false;
  File? _storyFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _storyFile = File(image.path);
        hasStory = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Story',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            if (hasStory) ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    hasStory = false;
                    _storyFile = null;
                  });
                },
                child: const Text('Cancel'),
              ),
              FutureBuilder<UserModel?>(
                  future: userProvider
                      .getUserById(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final user = snapshot.data;

                      return ElevatedButton(
                        onPressed: () async {
                          if (_storyFile != null) {
                            await userProvider.createStoryCollection(
                              user!.id,
                              _storyFile!,
                              user.name,
                              user.profilePicture.toString(),
                              DateTime.now().toIso8601String(),
                              user.id,
                              context,
                            );
                          }
                        },
                        child: Text(userProvider.isUploadStory
                            ? 'Uploading...'
                            : 'Upload'),
                      );
                    }
                    return const SizedBox();
                  }),
              const SizedBox(width: 15),
            ],
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!hasStory) ...[
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Story'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ] else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _storyFile!,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.7,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
