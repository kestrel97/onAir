import 'package:flutter/material.dart';
import 'models/response.dart';
import 'models/question.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'utils/functions.dart';

class QuestionDetails extends StatelessWidget {
  QuestionResponse response;
  Question question;

  QuestionDetails({Key key, this.question}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Question details"),
        ),
        body: FutureBuilder(
            future: getResponseByQuestionId(question.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                response = snapshot.data;
                if (response.image_link == null) {
                  return AlertDialog(
                    title: Text("No content"),
                    content:
                        Text("No responses recieved for this question yet."),
                  );
                }

                return Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: new Center(
                      child: ListView(
                    children: <Widget>[
                      new Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                          child: new ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              "Q: "+question.question,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      // new Card(
                      //   elevation: 8.0,
                      //   margin: new EdgeInsets.symmetric(
                      //       horizontal: 10.0, vertical: 6.0),
                      //   child: Container(
                      //     decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                      //     child: new ListTile(
                      //         contentPadding: EdgeInsets.symmetric(
                      //             horizontal: 20.0, vertical: 10.0),
                      //         title: CachedNetworkImage(
                      //           imageUrl: response.image_link,
                      //         )),
                      //   ),
                      // ),
                      new Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                          child: new ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              "Ans: "+response.response,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                );
              } else {
                return AlertDialog(
                    title: new Text("Fetching"),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Wrap(
                          children: <Widget>[
                            new CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    ));
              }
            }));
  }
}
