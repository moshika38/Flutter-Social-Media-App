class PostModel {
  final String id;
  final String title;
  final String imageUrl;
  final int? likeCount;
  final int? commentCount ;
  final String createTime;
  final String userId;

  PostModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.likeCount,
    this.commentCount,
    required this.createTime,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      likeCount: json['likeCount'] as int?,
      commentCount: json['commentCount'] as int?,
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
      'commentCount': commentCount,
      'createTime': createTime,
      'userId': userId,
    };
  }
}
