import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/providers/providers.dart';

import 'package:productosapp/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Productos App',
        theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[300]),
        initialRoute: 'login',
        routes: {
          'login': (_) => const LoginScreen(),
          'home': (_) => const HomeScreen(),
          'register': (_) => const RegisterScreen(),
        },
      ),
    );
  }
}
