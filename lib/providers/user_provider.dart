import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/widget/snack_bars.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  }

  //  create password based account
  Future<void> createAccount(
      String email, String password, BuildContext context, String uName) async {
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
      if (FirebaseAuth.instance.currentUser != null) {
        if (createUserProfile(FirebaseAuth.instance.currentUser!.uid, uName) ==
            true) {
          context.go('/home');
          notifyListeners();
        }
      }
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
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      SnackBars().showSuccessSnackBar(context, 'Reset password link sent');
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();
      if (!context.mounted) return;
      SnackBars().showErrSnackBar(context, errorMessage);
    }
    isLoading = false;
    notifyListeners();
  }

  // google login

  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (!context.mounted) return;
      if (userCredential.user != null) {
        SnackBars().showSuccessSnackBar(context, 'Google Sign In Successful');
        if (createUserProfile(userCredential.user!.uid, null) == true) {
          context.go('/home');
          notifyListeners();
        }
        context.go('/home');
      }
    } catch (e) {
      if (!context.mounted) return;
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();
      SnackBars().showErrSnackBar(context, errorMessage);
    }
    isLoading = false;
    notifyListeners();
  }

  // facebook login

  Future<void> signInWithFacebook(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status != LoginStatus.success) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      if (!context.mounted) return;
      if (userCredential.user != null) {
        SnackBars().showSuccessSnackBar(context, 'Facebook Sign In Successful');
        if (createUserProfile(userCredential.user!.uid, null) == true) {
          context.go('/home');
          notifyListeners();
        }
        context.go('/home');
      }
    } catch (e) {
      if (!context.mounted) return;
      errorMessage = e.toString().contains(']')
          ? e.toString().split('] ')[1]
          : e.toString();
      SnackBars().showErrSnackBar(context, errorMessage);
    }
    print('Error signing in with Facebook: $errorMessage');
    isLoading = false;
    notifyListeners();
  }

  // create user account
  Future<bool> createUserProfile(String uid, String? displayName) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    try {
      if (snapshot.exists == false) {
        final data = UserModel(
          id: uid,
          email: FirebaseAuth.instance.currentUser!.email!,
          name: displayName ??
              FirebaseAuth.instance.currentUser!.displayName ??
              "",
          profilePicture: FirebaseAuth.instance.currentUser!.photoURL ?? '',
          followers: [],
          following: [],
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(data.toJson());
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // get current user profile data
  Future<UserModel?> getUserById(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  // update user name
  Future<void> updateUserName(String uid, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'name': name});
    notifyListeners();
  }

  // upload user profile image
  Future<void> uploadImage(File? image, String uid) async {
    if (image == null) {
      debugPrint('No image provided');
      return;
    }

    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

    final cloudinary = Cloudinary.signedConfig(
      cloudName: cloudName,
      apiKey: apiKey,
      apiSecret: apiSecret,
    );

    try {
      final response = await cloudinary.upload(
        file: image.path,
        fileBytes: image.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: 'users',
        publicId: uid,
      );

      if (response.isSuccessful) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'profilePicture': response.secureUrl});
        notifyListeners();
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      debugPrint(e.toString());
      notifyListeners();
    }
  }
}
