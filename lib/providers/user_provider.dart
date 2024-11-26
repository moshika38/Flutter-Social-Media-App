import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app_flutter/widget/snack_bars.dart';

class UserProvider extends ChangeNotifier {
  UserCredential? _credential;
  UserCredential? get credential => _credential;

  String errorMessage = "";
  bool isLoading = false;

  // check user status
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
      SnackBars().showSuccessSnackBar(context, 'Account created successfully');
      // navigate to login page
      context.go('/login');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();

      SnackBars().showErrSnackBar(context, errorMessage);
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
        SnackBars().showSuccessSnackBar(context, 'Login Successfully');
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
      SnackBars().showErrSnackBar(context, errorMessage);
      isLoading = false;
      notifyListeners();
    }
  }

  // send reset password link
  Future<void> sendResetPasswordLink(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      SnackBars().showSuccessSnackBar(context, 'Reset password link sent');
    } catch (e) {
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();
      if (!context.mounted) return;
      SnackBars().showErrSnackBar(context, errorMessage);
    }
  }
}
