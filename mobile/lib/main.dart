import 'package:flutter/material.dart';
import 'ui/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'sign_in_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_screen.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() => runApp(new Splash());

class Splash extends StatelessWidget {

  Widget _widgetToDirect;
  Widget afterSplash(BuildContext context) {
    Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (BuildContext context) => _widgetToDirect));
  }

  void duringSplash() async {
    final bool isLoggedIn = await _googleSignIn.isSignedIn();

    if (isLoggedIn != null && isLoggedIn) {
      _widgetToDirect = MainScreen();
    } else {
      _widgetToDirect = SignInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'On Air',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
            imagePath: 'assets/onair.jpg',
            afterSplash: afterSplash,
            duringSplash: duringSplash,
            duration: 2500),
    );
  }
}