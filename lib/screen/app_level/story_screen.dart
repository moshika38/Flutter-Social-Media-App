import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/story_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/pages/story_view_page.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: const [ToggleThemeBtn()],
        ),
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) => FutureBuilder(
            future: userProvider
                .getUserById(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    // My Story Section
                    _buildMyStory(snapshot.data),

                    // body
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recent Updates',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    // Recent Updates List
                    FutureBuilder(
                      future: userProvider.checkFollowersStoryAvailableOrNot(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final availableUserList =
                              snapshot.data as List<UserModel>;
                          if (availableUserList.isEmpty) {
                            return const Center(
                              child: Text('No stories yet !'),
                            );
                          }
                          return Expanded(
                            child: ListView.builder(
                              itemCount: availableUserList.length,
                              itemBuilder: (context, index) {
                                return _buildStoryItem(
                                  index,
                                  availableUserList,
                                  userProvider,
                                );
                              },
                            ),
                          );
                        }
                        return const Center(
                          child: Text('No stories !'),
                        );
                      },
                    ),
                  ],
                );
              }
              return const Center(
                child: Text('Loading...'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMyStory(UserModel? user) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          context.pushNamed('create_story');
        },
        child: Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                user?.profilePicture == ""
                    ? AppUrl.baseUserUrl
                    : user!.profilePicture.toString(),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
      title: const Text(
        'My Status',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Tap to add status update'),
    );
  }

  Widget _buildStoryItem(int index, List<UserModel> availableUserList, UserProvider userProvider) {
    return FutureBuilder<StoryModel?>(
      future: userProvider.getStoryByStoryId(availableUserList[index].stories[0]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        final story = snapshot.data!;
        String date = "Not available";

        if (story.uploadTime.split("T")[0] != DateTime.now().toString().split("T")[0]) {
          final DateTime uploadTime = DateTime.parse(story.uploadTime);
          final Duration difference = DateTime.now().difference(uploadTime);

          if (difference.inMinutes < 60) {
            date = "${difference.inMinutes} minutes ago";
          } else if (difference.inHours < 24) {
            date = "${difference.inHours} hours ago";
          } else if (difference.inDays < 7) {
            date = "${difference.inDays} days ago";
          } else {
            date = "${uploadTime.day}/${uploadTime.month}/${uploadTime.year}";
          }
        } else {
          date = "Today ${story.uploadTime.split("T")[1].split(":")[0]}:${story.uploadTime.split("T")[1].split(":")[1]}";
        }

        return GestureDetector(
          onTap: () {
            StoryViewPage().showStoryView(context, false);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    availableUserList[index].profilePicture == ""
                        ? AppUrl.baseUserUrl
                        : availableUserList[index].profilePicture.toString(),
                  ),
                ),
              ),
              title: Text(
                availableUserList[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                date,
              ),
            ),
          ),
        );
      }
    );
  }
}
