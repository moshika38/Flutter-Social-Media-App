import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
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
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) => FutureBuilder(
            future: userProvider.getUserById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
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
                                      user.profilePicture ??
                                          "assets/images/user.jpg"),
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
                                    onPressed: () {},
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
                                  onPressed: () {},
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
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const SizedBox.shrink();
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
