import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  State<LoginHomePage> createState() => _LoginHomePage();
}

class _LoginHomePage extends State<LoginHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Google SignIn"),
        ),
        body: Column(children: [_googleSignInButton(), _githubSignInButton()]));
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign up with Google",
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }

  Widget _githubSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.gitHub,
          text: "Sign up with github",
          onPressed: _handleGitHubSignIn,
        ),
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
              ),
            ),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          MaterialButton(
            color: Colors.red,
            child: const Text("Sign Out"),
            onPressed: _auth.signOut,
          )
        ],
      ),
    );
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }

  void _handleGitHubSignIn() async {
    try {
      final result = await FlutterWebAuth.authenticate(
        url:
            "https://github.com/login/oauth/authorize?client_id=YOUR_CLIENT_ID&scope=user",
        callbackUrlScheme: "fluttergithubexample",
      );

      if (result != null) {
        final credential = GithubAuthProvider.credential(result);
        await _auth.signInWithCredential(credential);
      } else {
        print("GitHub sign in failed");
      }
    } catch (error) {
      print(error);
    }
  }
}
