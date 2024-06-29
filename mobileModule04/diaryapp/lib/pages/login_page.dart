import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool loading = false;

  void _handleGithubSignIn() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();

    try {
      await FirebaseAuth.instance.signInWithProvider(githubProvider);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print('Failed to sign in with GitHub: $e');
      setState(() {
        loading = false;
      });
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      loading = true;
    });
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
          loading = false;
        });
      } else {}
    } catch (error) {
      print(error);
      setState(() {
        loading = false;
      });
    }
  }

  Widget _signInButtons() {
    setState(() {
      loading = true;
    });
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
      body: loading ? CircularProgressIndicator() : _signInButtons(),
    );
  }
}