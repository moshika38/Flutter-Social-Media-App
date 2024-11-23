import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostBottomAppBar {
  void showPostBottomAppBar(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle create post
                    (context).pushNamed('create_post');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Create Post'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle create story
                    (context).pushNamed('create_story');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Create Story'),
                ),
              ],
            ),
          );
        });
  }
}
