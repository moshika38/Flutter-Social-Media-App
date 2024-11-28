import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/lost_connection.dart';
import 'package:test_app_flutter/widget/progress_bar.dart';
import 'package:test_app_flutter/widget/user_post.dart';

class AccountPage extends StatelessWidget {
  final String uid;
  const AccountPage({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) => FutureBuilder(
              future: userProvider.getUserById(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressBar();
                }

                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  bool isCurrentUser =
                      uid == FirebaseAuth.instance.currentUser!.uid
                          ? true
                          : false;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      user.profilePicture != ""
                                          ? user.profilePicture!
                                          : AppUrl.baseUserUrl,
                                    ),
                                  ),
                                ),
                                if (isCurrentUser)
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt),
                                      color: Colors.white,
                                      onPressed: () {
                                        _buildEditProfilePictureDialog(
                                          context,
                                          uid,
                                          userProvider,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isCurrentUser)
                                  IconButton(
                                    icon: const SizedBox.shrink(),
                                    onPressed: () {},
                                  ),
                                Text(
                                  user.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                if (isCurrentUser)
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _buildEditNameDialog(
                                        context,
                                        user.name,
                                        uid,
                                        userProvider,
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(context, '150', 'Posts'),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                                _buildStatColumn(
                                    context,
                                    user.followers!.length.toString(),
                                    'Followers'),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                                _buildStatColumn(
                                    context,
                                    user.following!.length.toString(),
                                    'Following'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (!isCurrentUser)
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.message_outlined),
                                label: const Text('Send Message'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 40),
                                ),
                              ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return UserPost(
                            isGoAccount: false,
                            userId: "1",
                            userImage: "assets/images/user.jpg",
                            userName: "John Doe",
                            postDes: "Beautiful day!",
                            postImage: "assets/images/post.jpg",
                            postTime: "${index + 1} days ago",
                            postLikes: "${(index + 1) * 100}",
                            postComments: "${(index + 1) * 10}",
                          );
                        },
                      ),
                    ],
                  );
                }

                return const LostConnection();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

void _buildEditNameDialog(
    BuildContext context, String name, String uid, UserProvider userProvider) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: name);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Edit Name',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            labelStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            errorStyle: const TextStyle(color: Colors.red),
            prefixIcon: const Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // TODO: Update name logic here
              userProvider.updateUserName(uid, nameController.text);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _buildEditProfilePictureDialog(
  BuildContext context,
  String uid,
  UserProvider userProvider,
) async {
  File? image0;
  final ImagePicker picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image0 != null) ...[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          image0!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    image0 = null;
                                  });
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                label: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  userProvider.uploadImage(image0, uid);
                                },
                                icon: const Icon(Icons.upload,
                                    color: Colors.white),
                                label: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                if (image0 == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setState(() {
                              image0 = File(image.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Choose from Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (photo != null) {
                            setState(() {
                              image0 = File(photo.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
