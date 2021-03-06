import 'package:OnAir/utils/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ui/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'sign_in_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(new Splash());

class Splash extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Widget nextWidget;

  Widget afterSplash(BuildContext context) {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => nextWidget));
  }

  void duringSplash() async {
    final bool isLoggedIn = await _googleSignIn.isSignedIn();

    if (isLoggedIn != null && isLoggedIn) {
      nextWidget = MainScreen();
    } else {
      nextWidget = SignInPage();
    }

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      saveFcmToken(token);
    });

    await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.contacts,
      PermissionGroup.location,
      PermissionGroup.sms
    ]);
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return new MaterialApp(
      title: 'On Air',
      theme: new ThemeData(
        brightness: Brightness.dark,
//        primaryColor: Color(0xFFffa726),
//        accentColor: Color(0xFFffd95b),
      primarySwatch: Colors.grey,

      ),
      home: SplashScreen(
          imagePath: 'assets/onair.png',
          afterSplash: afterSplash,
          duringSplash: duringSplash,
          duration: 500),
    );
  }
}
