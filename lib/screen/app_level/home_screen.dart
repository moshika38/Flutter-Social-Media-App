import 'package:flutter/material.dart';
import 'package:test_app_flutter/pages/story_view_page.dart';
import 'package:test_app_flutter/widget/user_post.dart';
import 'package:test_app_flutter/widget/post_bottom_app_bar.dart';

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
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                       
                      child: GestureDetector(
                        onTap: () {
                          PostBottomAppBar().showPostBottomAppBar(context);
                        },
                        child: const CreatePostBtn(),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        8,
                        (index) => GestureDetector(
                          onTap: () {
                            StoryViewPage().showStoryView(context, false);
                          },
                          child: const UserStoryCard(),
                        ),
                      ),
                    ),
                  ],
                ),
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

class UserStoryCard extends StatelessWidget {
  const UserStoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, // Increased size
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30, // Increased radius
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: const CircleAvatar(
              radius: 28, // Inner circle for border effect
              backgroundImage: AssetImage('assets/images/user.jpg'),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'User',
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CreatePostBtn extends StatelessWidget {
  const CreatePostBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Create  ',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            StoryViewPage().showStoryView(context, true);
          },
          child: Container(
            width: 70, // Increased size
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30, // Increased radius
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: const CircleAvatar(
                    radius: 23, // Inner circle for border effect
                    backgroundImage: AssetImage('assets/images/icon2.png'),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'News',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
