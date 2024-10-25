import 'package:leaf_lens/main.dart';
import 'package:flutter/material.dart';
import 'package:leaf_lens/pages/LoginPage.dart';
import 'SignUpPage.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:agriplant/core/utils/assets_data.dart';
//import 'package:leaf_lens/pages/vision_page.dart;
import 'homepage.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                  // const SizedBox(height: 60),
                  // Text(
                  //   "Please choose a laguage from the following to continue with",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 17),
                  //
                  // ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    // AppLocalizations.delegate.load(const Locale('hi')); // Change to Hindi
                    // setState(() {}); // Rebuild the UI with the new locale
                   // MyApp.setLocale(context, Locale('hi'));
                  },
                  child: Text('Hindi'),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    //MyApp.setLocale(context, Locale('te'));
                  },
                  child: Text('Espaneol'),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    //MyApp.setLocale(context, Locale('en'));
                  },
                  child: Text('English'),
                ),
              ],
            ),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Continue to SignUp'),
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.grey,
                // foregroundColor: Colors.white,
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
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              child: const Text(
                'Already have an account ? Login',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            // FilledButton.tonalIcon(
            //   onPressed: () {
            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //         builder: (context) => HomePage(),
            //       ),
            //     );
            //   },
            //   icon: const Icon(IconlyLight.addUser),
            //   label: const Text(
            //     'New here? Signup',
            //     //style: TextStyle(fontSize: 20),
            //   ),
            // ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
