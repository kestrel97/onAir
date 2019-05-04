import 'package:OnAir/utils/functions.dart';

import 'package:flutter/material.dart';
import 'question_details.dart';
import 'models/question.dart';

class QuestionsList extends StatefulWidget {
  QuestionsList({Key key, this.title, this.my_questions}) : super(key: key);

  final String title;
  final bool my_questions;

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Question question) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),

          title: Text(
            question.question,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),

          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionDetails(question: question)));
          },
        );

    Card makeCard(Question question) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color(0xFF0069C0)),
            child: makeListTile(question),
          ),
        );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: getQuestionsByUserId(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Question> questions = snapshot.data;
                return Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return makeCard(questions[index]);
                    },
                  ),
                );
              }

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
                  )
              );
            }));
  }
}