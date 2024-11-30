class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final String createTime;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.createTime,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      content: json['content'],
      createTime: json['createTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'content': content,
      'createTime': createTime,
    };
  }
}
