import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app_flutter/widget/toggle_theme_btn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: "assets/images/friends.jpg",
      title: "Connect with Friends",
      description: "Stay connected with friends and family around the world",
      icon: FontAwesomeIcons.userGroup,
    ),
    OnboardingItem(
      image: "assets/images/shair.jpg",
      title: "Share Your Moments",
      description: "Share your special moments with photos and stories",
      icon: FontAwesomeIcons.camera,
    ),
    OnboardingItem(
      image: "assets/images/chat.jpg",
      title: "Real-time Chat",
      description: "Chat instantly with your connections anytime, anywhere",
      icon: FontAwesomeIcons.solidComment,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [
          ToggleThemeBtn(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              _items[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _items[index].title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _items[index].description,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                        ?.withOpacity(0.7),
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _items.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: FaIcon(
                            _items[_currentPage].icon,
                            size: 35,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              if (_currentPage < _items.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                context.push('/login');
                              }
                            },
                            child: Text(
                              _currentPage < _items.length - 1
                                  ? 'Next '
                                  : 'Get Started ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
    required this.icon,
  });
}
