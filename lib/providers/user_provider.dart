import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProvider extends ChangeNotifier {
  UserCredential? _credential;
  UserCredential? get credential => _credential;

  String errorMessage = "";
  bool isLoading = false;

  // check user signing or not
  bool isUserSignedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  // sing out user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  //  create password based account
  Future<void> createAccount(
      String email, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      _credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign up Successfully',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // navigate to login page
      context.go('/login');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(errorMessage, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      isLoading = false;
      notifyListeners();
    }
  }

  //  login user with email and password

  Future<void> loginWithPassword(
      String email, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) return;
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login Successfully',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // navigate to home page
        context.go('/home');
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(errorMessage, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      isLoading = false;
      notifyListeners();
    }
  }
}
