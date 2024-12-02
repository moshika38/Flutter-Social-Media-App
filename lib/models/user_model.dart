class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final List<String> followers;
  final List<String> following;
  final List<String> stories;
  final List<String> chatsID;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.followers,
    required this.following,
    this.stories = const [],
    required this.chatsID,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      stories: List<String>.from(json['stories'] ?? []),
      chatsID: List<String>.from(json['chatsID'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'followers': followers,
      'following': following,
      'stories': stories,
      'chatsID': chatsID,
    };
  }
}
