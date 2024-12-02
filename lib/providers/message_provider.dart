import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app_flutter/models/massege_model.dart';
import 'package:test_app_flutter/models/user_model.dart';

class MessageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create new chat and save message
  Future<void> createNewChat(
      String senderId, String receiverId, String message) async {
    // chat id
    final chatId = getChatId(senderId, receiverId);

    // Create message data
    final messageData = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      messageType: 'text',
      timeStamp: DateTime.now().toIso8601String(),
      isSeen: false,
    ).toJson();

    // Add message to subCollection
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // update user chatsID
    await _firestore.collection('users').doc(senderId).update({
      'chatsID': FieldValue.arrayUnion([chatId]),
    });
    await _firestore.collection('users').doc(receiverId).update({
      'chatsID': FieldValue.arrayUnion([chatId]),
    });

    notifyListeners();
  }

  // update isSeen
  Future<void> updateIsSeen(String senderId, String receiverId) async {
    final chatId = getChatId(senderId, receiverId);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: receiverId)
        .where('isSeen', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({'isSeen': true});
      }
    });
    notifyListeners();
  }

  // return isSeen false massage count
  Future<int> getUnSeenMassageCount(String senderId, String receiverId) async {
    final chatId = getChatId(senderId, receiverId);
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: receiverId)
        .where('isSeen', isEqualTo: false)
        .get();
    return snapshot.docs.length;
  }

  // get chatID
  String getChatId(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    return ids[0] + ids[1];
  }

  // get all messages from chat as stream
  Stream<List<MessageModel>> getMessagesStream(
      String senderId, String reciverId) {
    final chatId = getChatId(senderId, reciverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
      messages.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      return messages;
    });
  }

  // delete message from chat by chatID
  Future<void> deleteMessage(
      String senderId, String recivedId, ) async {
    final chatId = getChatId(senderId, recivedId);

    // First delete all messages in the subcollection
    final messagesSnapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Update user's chatsID list to remove this chat
    final userDoc = await _firestore.collection('users').doc(senderId).get();
    if (userDoc.exists) {
      List<String> chatsID =
          List<String>.from(userDoc.data()?['chatsID'] ?? []);
      chatsID.remove(chatId);
      await _firestore.collection('users').doc(senderId).update({
        'chatsID': chatsID,
      });
    }

    // Then delete the chat document itself
    await _firestore.collection('chats').doc(chatId).delete();

    notifyListeners();
     
  }

  // clear chat
  Future<void> clearChat(String senderId, String recivedId) async {
    final chatId = getChatId(senderId, recivedId);
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    notifyListeners();
  }

  // Get receiver IDs from chat IDs as stream
  Stream<List<UserModel>> getChatUserIDListStream(
      List<String> chatIds, String currentUserId) {
    return Stream.fromFuture(Future(() async {
      List<UserModel> users = [];

      for (String chatId in chatIds) {
        // Extract receiver ID based on the concatenated format
        String receiverId = chatId.replaceAll(currentUserId, '');

        // Get user document
        final userDoc =
            await _firestore.collection('users').doc(receiverId).get();

        if (userDoc.exists) {
          users.add(UserModel.fromJson(userDoc.data() as Map<String, dynamic>));
        }
      }

      return users;
    }));
  }

  // get last message from chat
  Future<MessageModel?> getLastMessage(
      String senderId, String reciverId) async {
    final chatId = getChatId(senderId, reciverId);
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .limit(1)
        .get();
    return snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data()))
        .firstOrNull;
  }
}
