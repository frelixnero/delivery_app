import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // intsance of AuthServics
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _fireBaseAuth.currentUser;
  }

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _fireBaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      throw Exception(e.message);
    }
  }

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _fireBaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      print("General Error: $e");
      throw Exception(e.toString());
    }
  }

  // sign out
  Future<void> signOut() async {
    await _fireBaseAuth.signOut();
  }

  // error handling
}
