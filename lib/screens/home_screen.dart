import 'package:flutter/material.dart';
import 'package:productosapp/providers/providers.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final firebaseAuth = Provider.of<FirebaseProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromRGBO(63, 63, 156, 1), 
        actions: [
          IconButton(
            onPressed: () {
              firebaseAuth.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
      ),
    );
  }
}
