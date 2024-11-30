import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/post_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
 import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool hasImage = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        hasImage = true;
      });
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder: (BuildContext context, UserProvider userProvider,
              PostProvider postProvider, child) =>
          FutureBuilder<UserModel?>(
              future: userProvider.getUserById(
                  FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data!;

                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Create Post',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      actions: [
                        if (hasImage) ...[
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle post creation
                                postProvider.savePostToFirestore(
                                  _image!,
                                  userData.id,
                                  _postController.text,
                                  0,
                                  0,
                                  context,
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Text(postProvider.isLoading
                                    ? 'Uploading....'
                                    : 'Upload'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        userData.profilePicture ??
                                            AppUrl.baseUserUrl),
                                    radius: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    userData.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _postController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  hintText: "What's on your mind?",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueGrey,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              if (hasImage && _image != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _image!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image),
                                label: Text(
                                    hasImage ? 'Change Photo' : 'Add Photo'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const Center(child: ProgressBar());
              }),
    );
  }
}
