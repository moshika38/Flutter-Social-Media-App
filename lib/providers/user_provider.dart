import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserCredential? _credential;
  UserCredential? get credential => _credential;

  String errorMessage = "";
  bool loadingSingUp = false;

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
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    loadingSingUp = true;
    notifyListeners();
    try {
      _credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      loadingSingUp = false;
      notifyListeners();
    } catch (e) {
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
      loadingSingUp = false;
      notifyListeners();
    }
  }
}
