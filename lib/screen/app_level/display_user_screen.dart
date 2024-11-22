import 'package:flutter/material.dart';
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
    _tabController = TabController(length: 3, vsync: this);
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
          title: Text(
            'Friends',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            ToggleThemeBtn()
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).colorScheme.surface,
              labelColor: Theme.of(context).colorScheme.surface,
              tabs: const [
                Tab(text: 'Following'),
                Tab(text: 'Followers'),
                Tab(text: 'All Users'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Following Tab
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        Image.asset('assets/images/user.jpg').image,
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: const Text('You are following'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    child: const Text('Unfollow'),
                  ),
                );
              },
            ),
            // Followers Tab
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        Image.asset('assets/images/user.jpg').image,
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: const Text('Follows you'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    child: const Text('Follow Back'),
                  ),
                );
              },
            ),
            // All Users Tab
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              Image.asset('assets/images/user.jpg').image,
                        ),
                        title: Text('User ${index + 1}'),
                        subtitle: const Text('Suggested user'),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                          ),
                          child: const Text('Follow'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
