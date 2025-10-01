import 'package:firebase_auth/firebase_auth.dart';
class AuthServices {
  ///Register User
  Future<User> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user!;
    } catch (e) {
      throw e.toString();
    }
  }

  ///Login User
  Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user!;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Reset Password
  Future resetPassword(String email) async {
    try {
      return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
    }
  }
}
