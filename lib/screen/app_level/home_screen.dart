import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/post_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/pages/story_view_page.dart';
import 'package:test_app_flutter/providers/comment_provider.dart';
import 'package:test_app_flutter/providers/post_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/widget/progress_bar.dart';
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
            Consumer3<PostProvider, UserProvider, CommentProvider>(
              builder: (context, postProvider, userProvider, commentProvider,
                      child) =>
                  StreamBuilder(
                stream: postProvider.getAllPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: ProgressBar());
                  }
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          Text('No posts available yet !'),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final posts = snapshot.data as List<PostModel>;

                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream:
                                userProvider.getUserById(posts[index].userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final user = snapshot.data as UserModel;
                                return FutureBuilder<int>(
                                  future: commentProvider
                                      .getCommentCount(posts[index].id),
                                  builder: (context, commentSnapshot) {
                                    return UserPost(
                                      postId: posts[index].id,
                                      isGoAccount: true,
                                      userId: user.id,
                                      userImage: user.profilePicture.toString(),
                                      userName: user.name,
                                      postDes: posts[index].title,
                                      postImage: posts[index].imageUrl,
                                      postTime: posts[index].createTime,
                                      postLikes:
                                          posts[index].likeCount.toString(),
                                      postComments:
                                          commentSnapshot.data?.toString() ??
                                              '0',
                                    );
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                    child: Center(
                      child: Text('No posts found'),
                    ),
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
