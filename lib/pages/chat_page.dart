import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/massege_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/message_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  const ChatPage({super.key, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  UserModel? currentUser;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    messageProvider.updateIsSeen(
      FirebaseAuth.instance.currentUser!.uid,
      widget.receiverId,
    );
    userProvider
        .getUserById(FirebaseAuth.instance.currentUser!.uid)
        .then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, MessageProvider>(
      builder: (context, userProvider, messageProvider, child) => FutureBuilder(
        future: userProvider.getUserById(widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.trash, size: 18.0),
                    onPressed: () {
                      // Implement delete chat functionality
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          title: Column(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // delete chat
                                  await messageProvider.deleteMessage(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.receiverId,
                                  );
                                  context.pop();
                                  context.goNamed('chat');
                                },
                                child: Text(
                                  'Delete Chat',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              const Divider(),
                              TextButton(
                                onPressed: () {
                                  // clear chat
                                  messageProvider.clearChat(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.receiverId,
                                  );

                                  context.pop();
                                },
                                child: Text(
                                  'Clear Chat',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  StreamBuilder<List<MessageModel>>(
                    stream: messageProvider.getMessagesStream(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.receiverId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messages = snapshot.data!;
                        if (messages.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Start a conversation'),
                                  Text("Say 'Hello 👋' to get started"),
                                ],
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: messages.length,
                            reverse: true,
                            padding: const EdgeInsets.all(16.0),
                            itemBuilder: (context, index) {
                              if (messages[index].senderId ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                return _buildSendMessage(
                                  context,
                                  messages[index].message,
                                  messages[index]
                                      .timeStamp
                                      .split('T')[1]
                                      .split('.')[0],
                                  currentUser?.profilePicture != ""
                                      ? currentUser!.profilePicture.toString()
                                      : AppUrl.baseUserUrl,
                                );
                              } else {
                                return _buildRecivedMessage(
                                  context,
                                  messages[index].message,
                                  messages[index]
                                      .timeStamp
                                      .split('T')[1]
                                      .split('.')[0],
                                  user.profilePicture != ""
                                      ? user.profilePicture.toString()
                                      : AppUrl.baseUserUrl,
                                );
                              }
                            },
                          ),
                        );
                      }
                      return const Center(child: Text('Loading...'));
                    },
                  ),
                  _buildBottomInputBar(
                    context,
                    messageController,
                    () {
                      // Send Message
                      if (messageController.text.isNotEmpty) {
                        messageProvider.createNewChat(
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.receiverId,
                          messageController.text,
                        );
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // send message
  Widget _buildSendMessage(
    BuildContext context,
    String message,
    String timeStamp,
    String userImage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                      radius: 15, backgroundImage: NetworkImage(userImage)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 48.0),
              child: Text(
                timeStamp,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // received message
  Widget _buildRecivedMessage(
    BuildContext context,
    String message,
    String timeStamp,
    String userImage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userImage),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 48.0),
              child: Text(
                timeStamp,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // bottom input bar
  Widget _buildBottomInputBar(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
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
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.surface,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
