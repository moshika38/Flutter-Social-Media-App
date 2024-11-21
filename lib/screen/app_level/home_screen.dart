import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
          title: Center(
            child: Text(
              'Social Feed',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 100, // Increased height to accommodate larger avatars
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 11, // Increased to include the plus icon
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      width: 70, // Increased size
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25, // Increased radius
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: const Icon(Icons.add,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: 70, // Increased size
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25, // Increased radius
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: const CircleAvatar(
                              radius: 23, // Inner circle for border effect
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'User $index',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                            ),
                          ),
                          title: Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            '2 hours ago',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Having a great time with friends!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Image.asset(
                          'assets/images/post.jpg',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    '1.2k',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.comment_outlined),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    '84',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.share_outlined),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
