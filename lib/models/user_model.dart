class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final List<String>? followers;
  final List<String>? following;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.followers,
    this.following,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      followers: json['followers'] != null 
          ? List<String>.from(json['followers'])
          : null,
      following: json['following'] != null
          ? List<String>.from(json['following']) 
          : null,
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
    };
  }
}
