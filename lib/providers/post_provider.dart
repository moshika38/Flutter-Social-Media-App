import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app_flutter/models/post_model.dart';

class PostProvider with ChangeNotifier {
  bool isLoading =false;
  bool doneUpload =false;
  // add new post to firestore

  Future<void> savePostToFirestore(File image, String uid, String title,
      int likeCount, int commentCount) async {
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

      // Upload image and update imageUrl
      await uploadPost(image, docRef.id);

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving post: $e');
    }
  }

  // save post to cloudinary
  Future<void> uploadPost(File? image, String postId) async {
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
        folder: 'posts/$postId',
        publicId: postId,
      );

      if (response.statusCode == 200) {
        await FirebaseFirestore.instance.collection('posts').doc(postId).update(
          {'imageUrl': response.secureUrl},
        );
        isLoading = false;
        doneUpload = true;
        notifyListeners();
      }

      // save data to firebase
    } catch (e) {
      debugPrint(e.toString());
      notifyListeners();
    }
  }
}
