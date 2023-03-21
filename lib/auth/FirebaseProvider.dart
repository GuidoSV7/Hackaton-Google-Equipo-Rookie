import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _errorpassword = null;
  User? _user;

  bool _isChange = false;

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
    } catch (e) {
      print("error de firebase  ${e.toString()}");
      _errorpassword = e.toString();
      rethrow;
    }
  }

  Future<void> register({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("error de firebase  ${e.toString()}");
      rethrow;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get user => _user;

  String? get errorPassword => _errorpassword;

  bool get isChange => _isChange;

  set isChange( bool value ) {
    _isChange = value;
  }

}
