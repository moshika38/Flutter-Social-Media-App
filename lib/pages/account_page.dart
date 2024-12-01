import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/post_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/post_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';
import 'package:test_app_flutter/widget/user_post.dart';

class AccountPage extends StatefulWidget {
  final String uid;
  const AccountPage({
    super.key,
    required this.uid,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isFollowing = false;
  String postCount = "0";

  @override
  void initState() {
    super.initState();
    if (widget.uid.isEmpty) {
      print('Warning: Empty UID provided to AccountPage');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    postProvider.getUserPosts(widget.uid).then((value2) {
      if (mounted) {
        setState(() {
          postCount = value2.length.toString();
        });
      }
    });
    if (currentUser != null) {
      userProvider
          .checkUserFollowingOrNot(currentUser.uid, widget.uid)
          .then((value) {
        if (mounted) {
          setState(() {
            isFollowing = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uid.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: const Center(
          child: Text('Invalid user profile'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: const [
          ToggleThemeBtn(),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) => FutureBuilder<UserModel?>(
            future: userProvider.getUserById(widget.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                bool isCurrentUser =
                    widget.uid == FirebaseAuth.instance.currentUser!.uid
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
                                        widget.uid,
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              if (isCurrentUser)
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _buildEditNameDialog(
                                      context,
                                      user.name,
                                      widget.uid,
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
                              _buildStatColumn(context, postCount, 'Posts'),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (isFollowing) {
                                        isFollowing = false;
                                        userProvider.unFollowUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.uid);
                                      } else {
                                        isFollowing = true;
                                        userProvider.followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            [widget.uid],
                                            widget.uid);
                                      }
                                    },
                                    icon: const Icon(Icons.person_add_rounded,
                                        color: Colors.white),
                                    label: Text(
                                      isFollowing ? 'UnFollow' : 'Follow',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 150,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    label: Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Consumer<PostProvider>(
                      builder: (context, postProvider, child) => FutureBuilder(
                        future: postProvider.getUserPosts(widget.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              (snapshot.data as List<PostModel>).isEmpty) {
                            return const Column(
                              children: [
                                SizedBox(height: 50),
                                Text('No posts available yet !'),
                              ],
                            );
                          }
                          if (snapshot.hasData) {
                            final posts = snapshot.data as List<PostModel>;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return UserPost(
                                  postId: posts[index].id,
                                  isGoAccount: false,
                                  userId: posts[index].userId,
                                  userImage: user.profilePicture.toString(),
                                  userName: user.name,
                                  postDes: posts[index].title,
                                  postImage: posts[index].imageUrl,
                                  postTime: posts[index].createTime,
                                  postLikes: posts[index].likeCount.toString(),
                                  postComments:
                                      posts[index].commentCount.toString(),
                                );
                              },
                            );
                          }
                          return const Text('Loading...');
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text('Loading...'));
            },
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
