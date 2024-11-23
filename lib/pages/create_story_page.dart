import 'package:flutter/material.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  bool hasStory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Story',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (hasStory) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement story upload
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
            const SizedBox(width: 15),
          ],
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!hasStory) ...[
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement story picker
                  setState(() {
                    hasStory = true;
                  });
                },
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Story'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/post.jpg', // Replace with actual story image
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
