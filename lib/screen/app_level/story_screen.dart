import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            ToggleThemeBtn()
          ],
        ),
        body: Column(
          children: [
            // My Story Section
            ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        Image.asset('assets/images/user.jpg').image,
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
              title: const Text(
                'My Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Tap to add status update'),
            ),
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
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example count
                itemBuilder: (context, index) {
                  return ListTile(
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
                        backgroundImage:
                            Image.asset('assets/images/user.jpg').image,
                      ),
                    ),
                    title: Text(
                      'User ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Today, 10:00 AM'),
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
