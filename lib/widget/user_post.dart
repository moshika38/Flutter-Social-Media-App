import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/pages/comment_page.dart';
import 'package:test_app_flutter/providers/comment_provider.dart';
import 'package:test_app_flutter/providers/post_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/progress_bar.dart';

class UserPost extends StatefulWidget {
  final String userImage;
  final String userName;
  final String userId;
  final String postTime;
  final String postDes;
  final String postImage;
  final String postLikes;
  final String postComments;
  final String postId;
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
    required this.postId,
    required this.isGoAccount,
  });

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  bool isLike = false;
  bool isMoreIcon = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      userProvider
          .checkUserLikePost(currentUser.uid, widget.postId)
          .then((value) {
        if (mounted) {
          setState(() {
            isLike = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isMoreIcon ? 30 : 0,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(right: 28),
              child: isMoreIcon
                  ? Consumer2<PostProvider, CommentProvider>(
                      builder:
                          (context, postProvider, commentProvider, child) =>
                              Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              _showEditPostTab(
                                  context, widget.postId, widget.postDes);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              // TODO: delete
                              postProvider.deletePost(widget.postId);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  (context).pushNamed(
                    'account',
                    extra: widget.userId,
                  );
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
                    radius: widget.isGoAccount ? 20 : 15,
                    backgroundImage: NetworkImage(
                      widget.userImage.isNotEmpty
                          ? widget.userImage
                          : AppUrl.baseUserUrl,
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.userName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                widget.postTime.split('T')[0],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: widget.userId == FirebaseAuth.instance.currentUser!.uid
                  ? IconButton(
                      icon: Icon(isMoreIcon ? Icons.close : Icons.more_vert),
                      onPressed: () {
                        setState(() {
                          isMoreIcon = !isMoreIcon;
                        });
                      },
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer2<UserProvider, PostProvider>(
              builder: (context, userProvider, postProvider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      widget.postDes,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      if (isLike) {
                        isLike = false;
                        await userProvider.deleteUserLikePost(
                            widget.userId, widget.postId);
                        // await postProvider.deleteLikeCount(widget.postId, 1);
                      } else {
                        isLike = true;
                        await userProvider.updateUserLikePost(
                            widget.userId, [widget.postId], widget.postId);
                        // await postProvider.addLikeCount(widget.postId, 1);
                      }
                    },
                    child: widget.postImage.isNotEmpty
                        ? Image.network(
                            widget.postImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: ProgressBar());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error_outline),
                              );
                            },
                          )
                        : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLike ? Icons.favorite : Icons.favorite_border,
                                color: isLike ? Colors.red : null,
                              ),
                              onPressed: () async {
                                if (isLike) {
                                  isLike = false;
                                  await userProvider.deleteUserLikePost(
                                      widget.userId, widget.postId);
                                  // await postProvider.deleteLikeCount(
                                  //     widget.postId, 1);
                                } else {
                                  isLike = true;
                                  await userProvider.updateUserLikePost(
                                      widget.userId,
                                      [widget.postId],
                                      widget.postId);
                                  // await postProvider.addLikeCount(
                                  //     widget.postId, 1);
                                }
                              },
                            ),
                            Text(
                              widget.postLikes,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment_outlined),
                              onPressed: () {
                                CommentPage(postId: widget.postId)
                                    .showCommentSheet(context);
                              },
                            ),
                            Text(
                              widget.postComments,
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
            ),
          ),
        ],
      ),
    );
  }
}

void _showEditPostTab(BuildContext context, String postId, String postDes) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.primary,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final TextEditingController textController =
          TextEditingController(text: postDes);

      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Edit your post...',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[100]
                    : Theme.of(context).colorScheme.secondary,
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Save changes
                    Provider.of<PostProvider>(context, listen: false)
                        .updatePost(postId, textController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
