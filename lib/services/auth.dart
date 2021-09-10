import '../model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _userFromFirebaseUser(User user) {
    // return user != null ? AppUser(userId: user.uid) : null;
    return AppUser(userId: user.uid);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      // HelperFunctions().saveUserLoggedIn(true);
      return _userFromFirebaseUser(firebaseUser!);
    } catch (error) {
      print(error.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      // HelperFunctions().saveUserLoggedIn(true);
      return _userFromFirebaseUser(firebaseUser!);
    } catch (error) {
      print(error.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}
