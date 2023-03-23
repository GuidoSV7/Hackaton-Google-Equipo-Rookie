import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoginError = false;

  User? _user;

  FirebaseProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoginError = false;
    } catch (e) {
      isLoginError = true;
      rethrow;
    }
  }

  Future<void> register({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserDatabase({required String username,required String email, required String password,required String confirmpassword}) async {
    try {
      await _db.collection('user').add({
        'username':username,
        'email':email,
        'password':password,
        'confirmpassword':confirmpassword
      }); 
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get user => _user;

  bool get isLoginError => _isLoginError;

  set isLoginError( bool value ) {
    _isLoginError = value;
    notifyListeners();
  }

}
