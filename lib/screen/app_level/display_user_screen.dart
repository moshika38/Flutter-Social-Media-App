import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/search_bar.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';

class DisplayUserScreen extends StatefulWidget {
  const DisplayUserScreen({super.key});

  @override
  State<DisplayUserScreen> createState() => _DisplayUserScreenState();
}

class _DisplayUserScreenState extends State<DisplayUserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Friends',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: const [
            ToggleThemeBtn(),
            SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 10),
            TabBar(
              controller: _tabController,
              labelStyle: Theme.of(context).textTheme.titleMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
              tabs: const [
                Tab(text: 'Following'),
                Tab(text: 'Followers'),
              ],
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) => TabBarView(
                  controller: _tabController,
                  children: [
                    // Following Tab
                    FutureBuilder<List<UserModel>>(
                      future: userProvider.getCurrentUserFollowing(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final following = snapshot.data!;
                          if (following.isEmpty) {
                            return const Center(
                              child: Center(child: Text('No following users')),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: following.length,
                            itemBuilder: (context, index) {
                              return _buildFollowingCart(
                                index,
                                following[index].profilePicture.toString(),
                                following[index].name,
                                following[index].email,
                                () {
                                  userProvider.unFollowUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    following[index].id,
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const Center(
                          child: Text('Loading...'),
                        );
                      },
                    ),

                    // Followers Tab
                    FutureBuilder<List<UserModel>>(
                      future: userProvider.getCurrentUserFollowers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final followers = snapshot.data!;
                          if (followers.isEmpty) {
                            return const Center(
                              child: Text('No followers'),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: followers.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder<bool>(
                                future: userProvider.checkUserFollowingOrNot(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  followers[index].id,
                                ),
                                builder: (context, followSnapshot) {
                                  return _buildFollowersCart(
                                    index,
                                    followers[index].profilePicture.toString(),
                                    followers[index].name,
                                    followers[index].email,
                                    followSnapshot.data ?? false,
                                    () {
                                      followSnapshot.data ?? false
                                          ? userProvider.unFollowUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              followers[index].id,
                                            )
                                          : userProvider.followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              [followers[index].id],
                                              followers[index].id,
                                            );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const Center(
                          child: Text('Loading...'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowingCart(int index, String image, String username,
      String email, void Function() onPressed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            image.isNotEmpty ? image : AppUrl.baseUserUrl,
          ),
        ),
        title: Text(
          username,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Un Follow'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowersCart(int index, String image, String username,
      String email, bool alreadyFollow, void Function() onPressed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            image.isNotEmpty ? image : AppUrl.baseUserUrl,
          ),
        ),
        title: Text(
          username,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(alreadyFollow ? 'Un Follow' : 'Follow Back'),
            ),
          ],
        ),
      ),
    );
  }
}
