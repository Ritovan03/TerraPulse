import 'package:firebase_auth/firebase_auth.dart';
import 'package:leaf_lens/main.dart';
import 'package:flutter/material.dart';
import 'package:leaf_lens/pages/LoginPage.dart';
import 'package:leaf_lens/pages/SignUp1.dart';
import 'SignUpPage.dart';
import 'SignUp1.dart';
import 'homepage.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add this import

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Add this

  @override
  void initState() {
    super.initState();
    // Check if user is already signed in
    Future.delayed(Duration.zero, () {
      if (_auth.currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });

    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignUp1(),
          ),
        );
      }
    });
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in flow

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await _auth.signInWithCredential(credential);
    } catch (error) {
      print('Error during Google sign in: $error');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/welcome.gif',
                    width: 300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome to Terra Pulse !!",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Terra Pulse is a platform made for Wanderers, by Wanderers. Here you can explore the world and nature in a new way and make bio coins while doing, then you can redeem these bio coin for variou sustainable items in our market place.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.tonal(
                  onPressed: () {},
                  child: Text('Hindi'),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: Text('Espaneol'),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: Text('English'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _handleGoogleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Continue to SignUp'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: const Text(
                'Already have an account ? Login',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}