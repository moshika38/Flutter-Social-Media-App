import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/user_post.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
        child: Column(
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
                            color: Theme.of(context).colorScheme.surface,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/user.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@johndoe',
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
                      _buildStatColumn(context, '5.2K', 'Followers'),
                      Container(
                        height: 40,
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      _buildStatColumn(context, '1.5K', 'Following'),
                    ],
                  ),
                  const SizedBox(height: 16),
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
