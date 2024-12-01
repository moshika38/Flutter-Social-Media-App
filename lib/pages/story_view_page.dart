import 'package:flutter/material.dart';

class StoryViewPage {
  

  void showStoryView(BuildContext context, bool isDefault) {
    List<String> imageList = [
      "assets/images/sample.jpg",
      "assets/images/friends.jpg",
      "assets/images/post.jpg",
    ];
    List<String> defaultImageList = [
      "assets/images/friends.jpg",
      "assets/images/chat.jpg",
      "assets/images/shair.jpg",
    ];

    int currentStoryIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Stack(
                  children: [
                    // Story Image
                    GestureDetector(
                      onTapDown: (details) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        if (details.globalPosition.dx < screenWidth / 2) {
                          // Left tap - go back
                          if (currentStoryIndex > 0) {
                            setState(() {
                              currentStoryIndex--;
                            });
                          }
                        } else {
                          // Right tap - go forward
                          if (currentStoryIndex <
                              (isDefault ? defaultImageList : imageList)
                                      .length -
                                  1) {
                            setState(() {
                              currentStoryIndex++;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage((isDefault
                                ? defaultImageList
                                : imageList)[currentStoryIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Top Bar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  'assets/images/sample.jpg'), // user image
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'User Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '2h ago',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Story Progress Indicator
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        children: List.generate(
                          (isDefault ? defaultImageList : imageList).length,
                          (index) => Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: index <= currentStoryIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Views Section
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '1.2K views',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
