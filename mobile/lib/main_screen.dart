import 'dart:async';

import 'package:OnAir/question.dart';
import 'package:OnAir/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'invite_contacts.dart';
import 'utils/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: FutureBuilder<String>(
                future: getStringFromSharedPreferences(KEY_USER_NAME),
                initialData: '',
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData
                      ? new Text(snapshot.data)
                      : Container();
                }),
            accountEmail: FutureBuilder<String>(
                future: getStringFromSharedPreferences(KEY_IDENTIFIER),
                initialData: '',
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData
                      ? new Text(snapshot.data)
                      : Container();
                }),
            currentAccountPicture: Icon(
              Icons.account_circle,
              size: 70.0,
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text('Invite Contacts'),
            onTap: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (BuildContext context) => InviteContacts()));
            },
          ),
          ListTile(
            title: Text('Ask question'),
            onTap: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (BuildContext context) => AskQuestion()));
            },
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: () {
              _signOut();
            },
          ),
        ],
      ),
      ),
      appBar: new AppBar(
      title: new Text("OnAir"),
      iconTheme: new IconThemeData(color: Colors.white),
    ),
    );
  }

  Future<String> getStringFromSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key);
  }

  void _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    await _auth.signOut();
    _googleSignIn.signOut();

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => SignInPage()));
  }
}