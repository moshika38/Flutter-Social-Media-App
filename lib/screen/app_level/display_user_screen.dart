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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              labelStyle: Theme.of(context).textTheme.titleMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
              tabs: const [
                Tab(text: 'Following'),
                Tab(text: 'Followers'),
                Tab(text: 'Discover'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Following Tab
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/user.jpg'),
                          ),
                          title: Text(
                            'User ${index + 1}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '@username${index + 1}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Following'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Followers Tab
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/user.jpg'),
                          ),
                          title: Text(
                            'User ${index + 1}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '@username${index + 1}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Follow Back'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Discover Tab
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/user.jpg'),
                          ),
                          title: Text(
                            'User ${index + 1}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '@username${index + 1}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Suggested based on your interests',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Follow'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
