class NotificationModel {
  final String userId;
  final String title;
  final String body; 
  final DateTime time;

  NotificationModel({
    required this.userId,
    required this.title,
    required this.body,
    required this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'time': time.toIso8601String(),
    };
  }
}
