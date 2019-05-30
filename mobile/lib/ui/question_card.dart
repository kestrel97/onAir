import 'package:OnAir/models/question.dart';
import 'package:flutter/material.dart';

import '../question_details.dart';
import '../request_details.dart';

class QuestionCard extends StatefulWidget {

  Question question;
  bool is_response = false;

  QuestionCard({ this.question, this.is_response });

  @override
  _QuestionCardState createState() => new _QuestionCardState(question: question, is_response: is_response);
}

class _QuestionCardState extends State<QuestionCard> {

  Question question;
  bool is_response = false;

  _QuestionCardState({ this.question, this.is_response });


  @override
  Widget build(BuildContext context) {
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
                        (is_response != null && !is_response) ? QuestionDetails(question: question) : RequestDetails(question: question)));
            }),
      ),
    );
  }

}