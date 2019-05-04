import 'package:flutter/material.dart';
import 'models/response.dart';
import 'models/question.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QuestionDetails extends StatelessWidget {
  Response response = Response(
      image_link:
          "https://i1.sndcdn.com/artworks-000196901307-9ip9pi-t500x500.jpg",
      response:
          "System haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem haiSystem hai");
  Question question;

  QuestionDetails({Key key, this.question}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Question details"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: new Center(
            child: ListView(
          children: <Widget>[
            new Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color(0xFF0069C0)),
                child: new ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    question.question,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            new Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color(0xFF0069C0)),
                child: new ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: CachedNetworkImage(
                      imageUrl: response.image_link,
                    )),
              ),
            ),
            new Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color(0xFF0069C0)),
                child: new ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    response.response,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
