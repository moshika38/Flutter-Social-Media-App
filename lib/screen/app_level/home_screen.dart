import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/user_post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Social Feed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 100, // Increased height to accommodate larger avatars
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 11, // Increased to include the plus icon
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      width: 70, // Increased size
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25, // Increased radius
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: 70, // Increased size
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25, // Increased radius
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: const CircleAvatar(
                              radius: 23, // Inner circle for border effect
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'User $index',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const UserPost(
                    isGoAccount: true,
                    userId: "0",
                    userImage: "assets/images/user.jpg",
                    userName: "Jone Doe",
                    postDes: "my first post",
                    postImage: "assets/images/post.jpg",
                    postTime: "3 hours ago",
                    postLikes: "50k",
                    postComments: "50",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
