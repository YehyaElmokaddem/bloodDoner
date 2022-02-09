import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<User> signUp({
    String name,
    String password,
    String email,
    String phone,
    String civilId,
    String dob,
    String bloodType,
    String profilePhoto,
    bool isAdmin,
  }) async {
    try {
      final crendentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (crendentials.user == null) return null;
      await _db.collection('Users').doc(crendentials.user.uid).set({
        'name': name,
        'civil_ID': civilId,
        'phoneNumber': phone,
        'dateOfBirth': dob,
        'bloodType': bloodType,
        'email': email,
        'profilePhoto': profilePhoto,
        'isAdmin': false,
      });
      return crendentials.user;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<User> signIn({
    String password,
    String email,
  }) async {
    try {
      final crendentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return crendentials.user;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<String> resetPassword({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset link send to email';
    } catch (e) {
      print('$e');
      return 'Failed to Reset';
    }
  }
  Future<String> resetEmail(String newEmail) async {
    try {
      signIn();
      await _auth.currentUser.updateEmail(newEmail);
      return 'email changed succesfully';
    } catch (e) {
      print('$e');
      return 'Failed to change email';
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}
