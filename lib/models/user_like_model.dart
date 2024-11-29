class UserLikeModel {
  final String id;
  final String userId;
  final String postId;

  UserLikeModel({
    required this.id,
    required this.userId,
    required this.postId,
  });

  factory UserLikeModel.fromJson(Map<String, dynamic> json) {
    return UserLikeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      postId: json['postId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
    };
  }
}
