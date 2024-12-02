import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app_flutter/utils/app_url.dart';

class ChatUserCart extends StatelessWidget {
  final int index;
  final String userName;
  final String lastMassage;
  final String imageUrl;
  final String massageTime;
  final int? numMassage;
  final bool isSeen;
  final String senderId;

  const ChatUserCart({
    super.key,
    required this.index,
    required this.userName,
    required this.lastMassage,
    required this.imageUrl,
    this.numMassage,
    required this.massageTime,
    required this.isSeen,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 0,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    imageUrl == "" ? AppUrl.baseUserUrl : imageUrl),
                radius: 30,
              ),
              senderId != FirebaseAuth.instance.currentUser!.uid &&
                      numMassage != 0
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Center(
                          child: Text(
                            numMassage.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                massageTime,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    lastMassage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                senderId == FirebaseAuth.instance.currentUser!.uid && isSeen
                    ? Icon(
                        Icons.checklist_outlined,
                        color: Colors.green,
                      )
                    : Icon(Icons.checklist_outlined, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
