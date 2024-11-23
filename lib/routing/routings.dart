import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app_flutter/pages/account_page.dart';
import 'package:test_app_flutter/pages/chat_page.dart';
import 'package:test_app_flutter/screen/app_level/chat_screen.dart';
import 'package:test_app_flutter/screen/app_level/display_user_screen.dart';
import 'package:test_app_flutter/screen/app_level/settings_screen.dart';
import 'package:test_app_flutter/screen/app_level/story_screen.dart';
import 'package:test_app_flutter/screen/user_auth/forgot_password_screen.dart';
import 'package:test_app_flutter/screen/app_level/home_screen.dart';
import 'package:test_app_flutter/screen/user_auth/login_screen.dart';
import 'package:test_app_flutter/screen/app_level/main_screen.dart';
import 'package:test_app_flutter/screen/user_auth/on_boarding.dart';
import 'package:test_app_flutter/screen/user_auth/register_screen.dart';

class Routings {
  static bool isUser = false;
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  // this GlobalKey is help to hot reloading

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey, // this GlobalKey is help to hot reloading
    initialLocation: isUser ? '/home' : '/start',
    routes: [
      // app level routings
      GoRoute(
        name: "start",
        path: '/start',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: "login",
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: "register",
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: "forgot",
        path: '/forgot',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'home',
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                name: 'account',
                path: '/account',
                builder: (context, state) => const AccountPage(),
              ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'story',
                path: '/story',
                builder: (context, state) => const StoryScreen(),
                routes: const [
                   
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'friend',
                path: '/friend',
                builder: (context, state) => const DisplayUserScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'chat',
                path: '/chat',
                builder: (context, state) => const ChatScreen(),

                routes: [
                  GoRoute(
                    name: 'chat_page',
                    path: '/chat_page',
                    builder: (context, state) => const ChatPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'settings',
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: const [
                   
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
