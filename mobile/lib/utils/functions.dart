import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void postGmailAuthentication(FirebaseUser user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(KEY_FIREBASE_UID, user.uid);
  prefs.setString(KEY_IDENTIFIER, user.providerData[0].email);
  if (user.providerData[0].displayName != null) prefs.setString(KEY_USER_NAME, user.providerData[0].displayName);
}

void postPhoneAuthentication(FirebaseUser user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(KEY_FIREBASE_UID, user.uid);
  prefs.setString(KEY_IDENTIFIER, user.providerData[0].phoneNumber);
}