import 'dart:async';
import 'dart:convert';

import 'package:OnAir/ask_question.dart';
import 'package:OnAir/question_details.dart';
import 'package:OnAir/questions_list.dart';
import 'package:OnAir/sign_in_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'invite_contacts.dart';
import 'models/question.dart';
import 'utils/constants.dart';
import 'sign_up.dart';
import 'services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              accountName: FutureBuilder<String>(
                  future: getStringFromSharedPreferences(KEY_USER_NAME),
                  initialData: '',
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return snapshot.hasData
                        ? new Text(snapshot.data)
                        : Container();
                  }),
              accountEmail: FutureBuilder<String>(
                  future: getStringFromSharedPreferences(KEY_IDENTIFIER),
                  initialData: '',
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
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
              title: Text('Invite contacts'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => InviteContacts()));
              },
            ),
            ListTile(
              title: Text('Ask question'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => AskQuestion()));
              },
            ),
            ListTile(
              title: Text('My questions'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => QuestionsList(
                        title: "My questions", my_questions: true)));
              },
            ),
            ListTile(
              title: Text('My requests'),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => QuestionsList(
                        title: "My requests", my_questions: false)));
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
      body: MyHomePage(),
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
        CupertinoPageRoute(builder: (BuildContext context) => LoginSignupPage()));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cacheddata = new Map<int, Question>();
  var offsetLoaded = new Map<int, bool>();

  int _total = 0;

  @override
  void initState() {
    _getTotal().then((int total) {
      setState(() {
        _total = total;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _total,
        itemBuilder: (BuildContext context, int index) {
          Question question = _getData(index);
          return new Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  title: Text(
                    question.question,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuestionDetails(question: question)));
                  }),
            ),
          );
        });
  }

  Future<List<Question>> _getDatas(int offset) async {
    List<dynamic> list = await _getJson(offset);
    var datas = new List<Question>();
    list.forEach((obj) => datas.add(new Question.fromJson(obj)));
    return datas;
  }

  Future<List<dynamic>> _getJson(int offset) async {
    var response = await Dio()
        .get(BASE_END_POINT + "/api/questions/recent/" + offset.toString());
    return response.data;
  }

  Question _getData(int index) {
    Question data = cacheddata[index];
    if (data == null) {
      int offset = index ~/ 10 * 10;
      if (!offsetLoaded.containsKey(offset)) {
        offsetLoaded.putIfAbsent(offset, () => true);
        _getDatas(offset)
            .then((List<Question> datas) => _updateDatas(offset, datas));
      }
      data = new Question.loading();
    }

    return data;
  }

  Future<int> _getTotal() async {
    var response = await Dio().get(BASE_END_POINT + "/api/questions/count");
    return int.parse(response.data.toString());
  }

  void _updateDatas(int offset, List<Question> datas) {
    setState(() {
      for (int i = 0; i < datas.length; i++) {
        cacheddata.putIfAbsent(offset + i, () => datas[i]);
      }
    });
  }
}
