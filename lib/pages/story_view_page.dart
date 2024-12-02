import 'package:flutter/material.dart';
import 'package:test_app_flutter/utils/app_url.dart';

class StoryViewPage {
  final List<String> imageList;
  final String userName;
  final String userImage;
  final String uploadTime;

  StoryViewPage({
    required this.userName,
    required this.userImage,
    required this.uploadTime,
    required this.imageList,
  });

  void showStoryView(BuildContext context) {
    print("image is $imageList");
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
                          if (currentStoryIndex < imageList.length - 1) {
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
                            image: NetworkImage(imageList[currentStoryIndex]),
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
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(userImage != ""
                                  ? userImage
                                  : AppUrl.baseUserUrl), // user image
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  uploadTime,
                                  style: const TextStyle(
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
                          imageList.length,
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
