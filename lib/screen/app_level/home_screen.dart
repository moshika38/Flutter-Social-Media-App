import 'package:flutter/material.dart';
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
  int _selectedCategoryIndex = 0;

  final List<String> categories = [
    'All',
    'Followers',
    'Following',
  ];

  @override
  void initState() {
    super.initState();
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
            ToggleThemeBtn(),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 5),
            SizedBox(
              height: 80,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildActionBtn("Create", () {
                          PostBottomAppBar().showPostBottomAppBar(context);
                        }),
                        _buildActionBtn("News", () {}),
                        ...List.generate(
                          categories.length,
                          (index) => CategoryButton(
                            label: categories[index],
                            isSelected: _selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _buildActionBtn(String text, VoidCallback onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.surface
                    : Colors.grey,
              ),
        ),
      ),
    );
  }
}
