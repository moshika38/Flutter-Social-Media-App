class PostModel {
  final String id;
  final String title;
  final String imageUrl;
  final int? likeCount;
  final String createTime;
  final String userId;

  PostModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.likeCount,
    required this.createTime,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      likeCount: json['likeCount'] as int?,
      createTime: json['createTime'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'likeCount': likeCount,
      'createTime': createTime,
      'userId': userId,
    };
  }
}
