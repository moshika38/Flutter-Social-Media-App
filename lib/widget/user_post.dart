import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserPost extends StatelessWidget {
  final String userImage;
  final String userName;
  final String userId;
  final String postTime;
  final String postDes;
  final String postImage;
  final String postLikes;
  final String postComments;
  final bool isGoAccount;

  const UserPost({
    super.key,
    required this.userImage,
    required this.userName,
    required this.userId,
    required this.postTime,
    required this.postDes,
    required this.postImage,
    required this.postLikes,
    required this.postComments,
    required this.isGoAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:   EdgeInsets.symmetric(
          horizontal: isGoAccount ? 16 : 11, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isGoAccount
              ? ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      (context).pushNamed('account');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(userImage),
                      ),
                    ),
                  ),
                  title: Text(
                    userName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    postTime,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isGoAccount ? 16 : 10, vertical: 8),
            child: Text(
              postDes,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Image.asset(
            postImage,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    Text(
                      postLikes,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {},
                    ),
                    Text(
                      postComments,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
