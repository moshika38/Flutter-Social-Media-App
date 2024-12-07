import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/post_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/post_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/widget/post_bottom_app_bar.dart';
import 'package:test_app_flutter/widget/search_bar.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';
import 'package:test_app_flutter/widget/user_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Social Feed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          automaticallyImplyLeading: false,
          actions: [
            const ToggleThemeBtn(),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                (context).pushNamed("notification");
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            PostBottomAppBar().showPostBottomAppBar(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('Create'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            Consumer2<PostProvider, UserProvider>(
              builder: (context, postProvider, userProvider, child) =>
                  FutureBuilder(
                future: postProvider.getAllPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          Text('No posts available yet!'),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final posts = snapshot.data as List<PostModel>;

                    return Expanded(
                      child: ListView.builder(
                        controller:
                            scrollController, // Attach the controller here
                        physics: const BouncingScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future:
                                userProvider.getUserById(posts[index].userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final user = snapshot.data as UserModel;
                                return UserPost(
                                  postId: posts[index].id,
                                  isGoAccount: true,
                                  postPublishUserId: user.id,
                                  userImage: user.profilePicture.toString(),
                                  userName: user.name,
                                  postDes: posts[index].title,
                                  postImage: posts[index].imageUrl,
                                  postTime: posts[index].createTime,
                                  postLikes: posts[index].likeCount.toString(),
                                  postComments:
                                      posts[index].commentCount.toString(),
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
                      child: Text('Loading...'),
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
