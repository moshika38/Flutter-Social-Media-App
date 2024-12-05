import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus the text field when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Back'),
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) => Column(
            children: [
              // search bar
              PrimarySearchBar(
                controller: _searchController,
                focusNode: _searchFocus,
              ),

              SizedBox(height: 30),
              // search result
              StreamBuilder(
                stream: userProvider.searchUser(_searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Searching...'));
                  }
                  if (snapshot.hasData) {
                    final users = snapshot.data as List<UserModel>;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return _buildUserDisplayCard(
                            index,
                            users[index].id,
                            users[index].name,
                            users[index].profilePicture ?? '',
                            userProvider,
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text('Loading...'));
                },
              ),

              // page end
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Widget _buildUserDisplayCard(int index, String userID, String userName,
      String profileImage, UserProvider userProvider) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          (context).pushNamed(
            'account',
            extra: userID,
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            profileImage == '' ? AppUrl.baseUserUrl : profileImage,
          ),
        ),
      ),
      title: Text(userName),
      trailing: FutureBuilder<bool>(
        future: userProvider.checkUserFollowingOrNot(
            FirebaseAuth.instance.currentUser!.uid, userID),
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: () {
              if (snapshot.data == true) {
                userProvider.unFollowUser(
                    FirebaseAuth.instance.currentUser!.uid, userID);
              } else {
                userProvider.followUser(
                    FirebaseAuth.instance.currentUser!.uid, [userID], userID);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: Text(
              snapshot.data == true ? 'Un Follow' : 'Follow',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

class PrimarySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const PrimarySearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Search messages...',
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
