import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  bool loading;
  final Function(bool) setLoading;
  LoginPage({required this.loading, required this.setLoading, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  void _handleGithubSignIn() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();

    widget.setLoading(true);

    try {
      await FirebaseAuth.instance.signInWithProvider(githubProvider);

      widget.setLoading(false);
    } catch (e) {
      print('Failed to sign in with GitHub: $e');
    }
    widget.setLoading(false);
  }

  void _handleGoogleSignIn() async {
    widget.setLoading(true);
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
        await FirebaseAuth.instance.signInWithCredential(credential);
        widget.setLoading(false);
      } else {
        widget.setLoading(false);
      }
    } catch (error) {
      print("error");
      print(error);
    }
    widget.setLoading(false);
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
          onPressed: _handleGithubSignIn,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: widget.loading
          ? const Center(child: CircularProgressIndicator())
          : _signInButtons(),
    );
  }
}