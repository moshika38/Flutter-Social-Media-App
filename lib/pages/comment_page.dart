import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/comment_model.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/comment_provider.dart';
import 'package:test_app_flutter/providers/post_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';

class CommentPage {
  final String postId;

  CommentPage({
    required this.postId,
  });

  final TextEditingController commentController = TextEditingController();

  void showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Consumer3<CommentProvider, UserProvider, PostProvider>(
              builder: (context, commentProvider, userProvider, postProvider,
                  child) {
                return FutureBuilder<List<CommentModel>>(
                  future: commentProvider.getComments(postId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final comments = snapshot.data!;

                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Comments',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: comments.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                              comments[index].userImage),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        comments[index]
                                                            .userName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                      comments[index].userId ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                          ? Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    FontAwesomeIcons
                                                                        .pen,
                                                                    size: 16,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    // Handle edit
                                                                  },
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  constraints:
                                                                      const BoxConstraints(),
                                                                ),
                                                                const SizedBox(
                                                                    width: 12),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    FontAwesomeIcons
                                                                        .trash,
                                                                    size: 16,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface,
                                                                  ),
                                                                  onPressed:
                                                                      () async{
                                                                    // Handle delete
                                                                    await commentProvider
                                                                        .deleteComment(
                                                                            comments[index].id);

                                                                    // update count
                                                                    await postProvider
                                                                        .deleteCommentCount(
                                                                            postId,
                                                                            1);
                                                                  },
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  constraints:
                                                                      const BoxConstraints(),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    comments[index].content,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 4),
                                              child: Text(
                                                comments[index]
                                                    .createTime
                                                    .split(' ')[0],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 8,
                              right: 8,
                              top: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Type a comment...',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
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
                                              .surface
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                FutureBuilder<UserModel?>(
                                  future: userProvider.getUserById(
                                      FirebaseAuth.instance.currentUser!.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final userData = snapshot.data!;
                                      return IconButton(
                                        onPressed: () async{
                                          // add comment
                                         await commentProvider.saveComment(
                                            postId,
                                            commentController.text,
                                            userData.id,
                                            userData.name,
                                            userData.profilePicture.toString(),
                                          );
                                          commentController.clear();

                                          // update count
                                          await postProvider.addCommentCount(
                                              postId, 1);
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      );
                                    }
                                    return IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.send,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
