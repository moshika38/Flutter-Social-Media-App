import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app_flutter/models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  // get comments
  Stream<List<CommentModel>> getComments(String postId) async* {
    var comments = await FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();
    final data =
        comments.docs.map((doc) => CommentModel.fromJson(doc.data())).toList();

    data.sort((a, b) =>
        DateTime.parse(b.createTime).compareTo(DateTime.parse(a.createTime)));

    yield data;
  }

  // save comment
  Future<void> saveComment(String postId, String content, String userId,
      String userName, String userImage) async {
    final docRef = FirebaseFirestore.instance.collection('comments').doc();
    final comment = CommentModel(
      id: docRef.id,
      postId: postId,
      content: content,
      userId: userId,
      userName: userName,
      userImage: userImage,
      createTime: DateTime.now().toString(),
    );
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(docRef.id)
        .set(comment.toJson());

    notifyListeners();
  }

  // delete comment
  Future<void> deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(commentId)
        .delete();
    notifyListeners();
  }

  // edit comment
  Future<void> editComment(String commentId, String content) async {
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(commentId)
        .update({'content': content});
    notifyListeners();
  }

  // return comment count by postId
  int count = 0;
  Future<int> getCommentCount(String postId) async {
    final comments = await FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();

    print("comment count is ${comments.docs.length}");
    count = comments.docs.length;
    return count;
  }
}
