import 'package:OnAir/utils/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Detailpage.dart';
import 'models/question.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
      home: new ListPage(title: 'Lessons'),
      // home: DetailPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  

  ListPage({Key key, this.title}) : super(key: key);

  Widget nextWidget;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Question question= Question(question: "hello world");
  List lessons;

  @override
  void initState() {
    lessons = getLessons();
    super.initState();
  }

  void duringSplash() async {
    final bool isLoggedIn = await _googleSignIn.isSignedIn();

          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(question:question)));
          },
        );

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      saveFcmToken(token);
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
