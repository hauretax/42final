import 'package:diaryfinalapp/pages/home_page.dart';
import 'package:diaryfinalapp/pages/login_page.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';
  User? _user;
  bool loading = false;
  setLoading(bool load) {
    setState(() {
      loading = load;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      setState(() {
        _user = _auth.currentUser;
      });
    }
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: _user != null
          ? HomePage(user: _user!)
          : LoginPage(
              loading: loading,
              setLoading: setLoading,
            ),
    );
  }
}
