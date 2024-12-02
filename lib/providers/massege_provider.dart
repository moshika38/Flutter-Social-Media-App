import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app_flutter/models/massege_model.dart';

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
    ).toJson();

    // Add message to subCollection
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  // get chatID
  String getChatId(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    return ids[0] + ids[1];
  }

  // get all messages from chat as stream
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  // delete message from chat
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  // delete chat
  Future<void> deleteChat(String chatId) async {
    await _firestore.collection('chats').doc(chatId).delete();
  }

  // get all chats from user as stream
  Stream<List<String>> getChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('senderId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // get all users from chat as stream
  Stream<List<String>> getUsersFromChatStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}
