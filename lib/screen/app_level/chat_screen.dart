import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/massege_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/message_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/widget/chat_user_cart.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Messages',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: const [ToggleThemeBtn()],
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
            Consumer2<MessageProvider, UserProvider>(
              builder: (context, messageProvider, userProvider, child) =>
                  FutureBuilder<UserModel?>(
                future: userProvider
                    .getUserById(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  return StreamBuilder<List<UserModel>>(
                    stream: messageProvider.getChatUserIDListStream(
                        snapshot.data?.chatsID ?? [],
                        FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final allUser = snapshot.data;

                        if (allUser!.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Start a conversation'),
                                  Text(
                                      "Search or Follow user to start a conversation"),
                                  Text("And Say 'Hello 👋' to get started"),
                                ],
                              ),
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: allUser.length, // Example count
                            itemBuilder: (context, index) {
                              return FutureBuilder<MessageModel?>(
                                future: messageProvider.getLastMessage(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    allUser[index].id),
                                builder: (context, messageSnapshot) {
                                  // get unSeen massage count
                                  return FutureBuilder<int>(
                                    future:
                                        messageProvider.getUnSeenMassageCount(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            allUser[index].id),
                                    builder: (context, unreadSnapshot) {
                                      return GestureDetector(
                                        onTap: () {
                                          context.pushNamed('chat_page',
                                              extra: allUser[index].id);
                                        },
                                        child: ChatUserCart(
                                          senderId:
                                              messageSnapshot.data?.senderId ??
                                                  "",
                                          index: index,
                                          userName: allUser[index].name,
                                          lastMassage:
                                              messageSnapshot.data?.message ??
                                                  '',
                                          imageUrl: allUser[index]
                                              .profilePicture
                                              .toString(),
                                          massageTime: messageSnapshot
                                                  .data?.timeStamp
                                                  .split('T')[1]
                                                  .split('.')[0] ??
                                              '',
                                          numMassage: unreadSnapshot.data ?? 0,
                                          isSeen:
                                              messageSnapshot.data?.isSeen ==
                                                      true
                                                  ? true
                                                  : false,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
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
