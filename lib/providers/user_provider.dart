import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 

class UserProvider extends ChangeNotifier {
  // check user signing or not
  bool isUserSignedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }



}
