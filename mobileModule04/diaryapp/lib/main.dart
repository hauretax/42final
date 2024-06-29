import 'package:diaryapp/pages/home_page.dart';
import 'package:diaryapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  String errorMessage = '';
  User? _user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Auth Demo',
        home: _user != null ? HomePage() : LoginPage());
  }
}
