import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:"AIzaSyDP-bk6lnZ6asjv9lvKGu6uuQR5uFyjtQA",
      appId: "1:741583686279:android:fc80d06a5f2bc58cfd8622",
      messagingSenderId: '741583686279',
      projectId: 'user-data-cf0bf',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: LoginPage(),
    );
  }
}