import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  
  FirebaseProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    //_db.collection('users').snapshots().listen(_onUsersChanged);
  }
  
  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  // void _onUsersChanged(QuerySnapshot<Map<String, dynamic>> snapshot) {
  //   // Maneje los cambios en la colección de "user" aquí.
  //   // Por ejemplo, podría actualizar una lista de usuarios almacenados en su clase.
  //   notifyListeners();
  // }

  Future<bool> login({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
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

}
