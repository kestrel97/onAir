import 'dart:io';

import 'package:OnAir/utils/functions.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'question_details.dart';
import 'models/question.dart';
import 'models/response.dart';

class RequestDetail extends StatefulWidget {
  Question question;
  RequestDetail({Key key, this.question}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return RequestDetailState(question: question);
  }
}

class RequestDetailState extends State<RequestDetail> {
  Question question;
  File _image;

  @override
  RequestDetailState({this.question});
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Response")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          child: new Center(
            child: ListView(
              children: <Widget>[
                new Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xFF0069C0)),
                    child: new ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
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
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xFF0069C0)),
                    child: Column(children: <Widget>[
                      new ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        title: new TextFormField(
                          decoration: new InputDecoration(
                              hintText: "Write your query here",
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(),
                              )),
                          maxLines: null,
                          minLines: 5,
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                      new RaisedButton(
                        onPressed: getImage,
                        child: new Text('Capture Image'),
                      ),
                      
                    ]
                    
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
