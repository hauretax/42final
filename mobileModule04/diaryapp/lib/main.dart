import 'package:diaryapp/pages/home_page.dart';
import 'package:diaryapp/screens/login.dart';
import 'package:diaryapp/screens/profile.dart';
import 'package:diaryapp/services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

const appScheme = 'flutterdiaryapp';
void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  String errorMessage = '';
  Credentials? _credentials;
  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    final auth0Domain = dotenv.env['AUTH0_DOMAIN']!;
    final auth0ClientId = dotenv.env['AUTH0_CLIENT_ID']!;
    auth0 = Auth0(auth0Domain, auth0ClientId);
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final Credentials credentials =
          await auth0.webAuthentication(scheme: appScheme).login();

      setState(() {
        isBusy = false;
        _credentials = credentials;
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await auth0.webAuthentication(scheme: appScheme).logout();

    setState(() {
      _credentials = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = DatabaseService();
    return MaterialApp(
      title: 'Auth0 Demo',
      home: (_credentials != null)
          ? HomePage()
          : Scaffold(
              appBar: AppBar(
                title: const Text('Auth0 Demo'),
              ),
              body: Column(
                children: [
                  TextButton(onPressed: data.test, child: Text("test")),
                  Center(
                    child: isBusy
                        ? const CircularProgressIndicator()
                        : _credentials != null
                            ? Profile(logoutAction, _credentials?.user)
                            : Login(loginAction, errorMessage),
                  ),
                ],
              ),
            ),
    );
  }
}
