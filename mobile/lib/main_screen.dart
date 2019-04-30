import 'package:OnAir/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'invite_contacts.dart';

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
            accountName: new Text("Saad Ismail"),
            accountEmail: new Text("saad3112@gmail.com"),
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

  void _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

//    final FirebaseUser user = await _auth.signInWithCredential(credential);

    _googleSignIn.signOut();

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => SignInPage()));
  }
}