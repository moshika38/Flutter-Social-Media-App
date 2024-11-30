import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app_flutter/models/post_model.dart';

class PostProvider with ChangeNotifier {
  bool isLoading = false;

  // add new post to firestore

  Future<void> savePostToFirestore(File image, String uid, String title,
      int likeCount, int commentCount, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final docRef = FirebaseFirestore.instance.collection('posts').doc();

      final post = PostModel(
        id: docRef.id,
        title: title,
        imageUrl: '',
        likeCount: likeCount,
        commentCount: commentCount,
        createTime: DateTime.now().toIso8601String(),
        userId: uid,
      );

      await docRef.set(post.toJson());
      if (context.mounted) {
        await uploadPost(image, docRef.id, context);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving post: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  // save post to cloudinary
  Future<void> uploadPost(
      File? image, String postId, BuildContext context) async {
    if (image == null) {
      debugPrint('No image provided');
      return;
    }

    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

    final cloudinary = Cloudinary.signedConfig(
      cloudName: cloudName,
      apiKey: apiKey,
      apiSecret: apiSecret,
    );

    try {
      final response = await cloudinary.upload(
        file: image.path,
        fileBytes: image.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: 'posts',
        publicId: postId,
      );

      if (response.statusCode == 200) {
        await FirebaseFirestore.instance.collection('posts').doc(postId).update(
          {'imageUrl': response.secureUrl},
        );
        isLoading = false;
        if (context.mounted) {
          context.pushNamed('home');
        }
        notifyListeners();
      }

      // save data to firebase
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;

      notifyListeners();
    }
  }

  // get user posts
  Future<List<PostModel>> getUserPosts(String userId) async {
    final posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();
    final data =
        posts.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    data.sort((a, b) => b.createTime.compareTo(a.createTime));
    return data;
  }

  // delete post
  Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;
    final cloudinary = Cloudinary.signedConfig(
      cloudName: cloudName,
      apiKey: apiKey,
      apiSecret: apiSecret,
    );
    await cloudinary.destroy('posts/$postId');
    notifyListeners();
  }

  // update post description
  Future<void> updatePost(String postId, String title) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'title': title,
    });
    notifyListeners();
  }

  // get all posts

  Future<List<PostModel>> getAllPosts() async {
    final posts = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createTime',
            descending: true) // Order by createTime in descending order
        .get();

    return posts.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  }

  // add comment count
  Future<void> addCommentCount(String postId, int count) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(count),
    });
    notifyListeners();
  }

  // delete comment count
  Future<void> deleteCommentCount(String postId, int count) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(-count),
    });
    notifyListeners();
  }
}
