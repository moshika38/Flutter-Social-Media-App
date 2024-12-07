import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.onPrimary),
            label: Text(
              "Clear all",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: sampleNotifications.length,
                  itemBuilder: (context, index) {
                    return NotificationItem(
                        notification: sampleNotifications[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final Notification notification;

  const NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "2023/12/12",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Card(
                  child: Text("Clear"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Notification {
  final String title;
  final String message;
  final String time;

  Notification({
    required this.title,
    required this.message,
    required this.time,
  });
}

final List<Notification> sampleNotifications = [
  Notification(
    title: "New Message",
    message: "You have received a new message",
    time: "2m ago",
  ),
  Notification(
    title: "System Update",
    message: "A new system update is available",
    time: "1h ago",
  ),
  Notification(
    title: "Reminder",
    message: "Meeting starts in 15 minutes",
    time: "15m ago",
  ),
];
