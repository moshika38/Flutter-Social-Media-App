import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app_flutter/widget/chat_user_cart.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Messages',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
           ToggleThemeBtn()
          ],
        ),
        body: Column(
          children: [
            // Search bar
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            // Chat list
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example count
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed('chat_page');
                    },
                    child: ChatUserCart(
                      index: index,
                      userName: 'User ${index + 1}',
                      lastMassage: 'Hey! How are you doing?',
                      imageUrl: 'assets/images/user.jpg',
                      massageTime: '12:30 PM',
                      numMassage: 2,
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
