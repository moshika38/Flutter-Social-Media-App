class MessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final String timeStamp;
  final String messageType;
  final bool isSeen;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timeStamp,
    required this.messageType,
    required this.isSeen,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      timeStamp: json['timeStamp'] as String,
      messageType: json['messageType'] as String,
      isSeen: json['isSeen'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamp': timeStamp,
      'messageType': messageType,
      'isSeen': isSeen,
    };
  }
}
