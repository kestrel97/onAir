import 'package:OnAir/ui/question_card.dart';
import 'package:OnAir/utils/functions.dart';

import 'package:flutter/material.dart';
import 'question_details.dart';
import 'models/question.dart';
import 'request_details.dart';

class QuestionsList extends StatefulWidget {
  QuestionsList({Key key, this.title, this.my_questions}) : super(key: key);

  final String title;
  bool my_questions;

  @override
  _QuestionsListState createState() =>
      _QuestionsListState(my_questions: my_questions);
}

class _QuestionsListState extends State<QuestionsList> {
  bool my_questions;

  _QuestionsListState({this.my_questions});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future:
                (my_questions) ? getQuestionsByUserId() : getRequestsByUserId(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Question> questions = snapshot.data;
                return Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (my_questions) ? QuestionCard(question: questions[index], is_response: false) : QuestionCard(question: questions[index], is_response: true);
//                      return makeCard(questions[index]);
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
                  ));
            }));
  }
}
