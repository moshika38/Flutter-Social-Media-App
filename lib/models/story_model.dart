class StoryModel {
  final String id;
  final String imageUrl;
  final String userName;
  final String userProfile;
  final String uploadTime;
  final String userId;

  StoryModel({
    required this.id,
    required this.imageUrl,
    required this.userName,
    required this.userProfile,
    required this.uploadTime,
    required this.userId,
    });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      userName: json['userName'] as String,
      userProfile: json['userProfile'] as String,
      uploadTime: json['uploadTime'] as String,
      userId: json['userId'] as String,
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'userName': userName,
      'userProfile': userProfile,
      'uploadTime': uploadTime,
      'userId': userId,
    };
  }
}


