import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
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
        title: const Text("Sign In"),
      ),
      body: _user != null ? _userInfo() : _signInButtons(),
    );
  }

  Widget _signInButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SignInButton(
          Buttons.google,
          text: "Sign up with Google",
          onPressed: _handleGoogleSignIn,
        ),
        SignInButton(
          Buttons.gitHub,
          text: "Sign up with GitHub",
          onPressed: () async {
            GithubAuthProvider githubProvider = GithubAuthProvider();
            try {
              // Sign in avec GitHub en utilisant Firebase
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithProvider(githubProvider);

              // Utilisation de userCredential.user pour accéder à l'utilisateur connecté
              print(
                  'Signed in with GitHub: ${userCredential.user!.displayName}');

              return userCredential;
            } catch (e) {
              // Gestion des erreurs
              print('Failed to sign in with GitHub: $e');
              rethrow; // Renvoie l'erreur pour la gestion supplémentaire si nécessaire
            }
          },
        ),
      ],
    );
  }

  Widget _userInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_user!.photoURL != null)
          CircleAvatar(
            backgroundImage: NetworkImage(_user!.photoURL!),
            radius: 50,
          ),
        const SizedBox(height: 16),
        Text(_user!.email ?? ""),
        Text(_user!.displayName ?? ""),
        const SizedBox(height: 16),
        MaterialButton(
          color: Colors.red,
          child: const Text("Sign Out"),
          onPressed: _auth.signOut,
        ),
      ],
    );
  }

  void _handleGoogleSignIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          _user = userCredential.user;
        });
      } else {}
    } catch (error) {
      print(error);
    }
  }
}
