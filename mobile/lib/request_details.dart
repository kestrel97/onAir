import 'dart:io';

import 'package:OnAir/utils/constants.dart';
import 'package:OnAir/utils/functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'main_screen.dart';
import 'models/question.dart';

class RequestDetails extends StatefulWidget {
  Question question;
  RequestDetails({Key key, this.question}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return RequestDetailsState(question: question);
  }
}

class RequestDetailsState extends State<RequestDetails> {
  Question question;
  File _image;
  TextEditingController _responseController = new TextEditingController();
  bool _isLoading = false;

  @override
  RequestDetailsState({this.question});

  void getImageByCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void getImageByGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  uploadFileFromDio(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    FormData formData = new FormData();
    formData.add("question", question.id);
    formData.add("sender", await getUid());
    formData.add("response", _responseController.text);

    if (_image != null && _image.path != null && _image.path.isNotEmpty) {
      // Create a FormData
      String fileName = basename(_image.path);
      formData.add("image", new UploadFileInfo(_image, fileName));
    }

    var response = await Dio().post(BASE_END_POINT + "/api/responses/create",
        data: formData,
        options: Options(
            method: 'POST',
            responseType: ResponseType.plain // or ResponseType.JSON
            ));
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).push(
        CupertinoPageRoute(builder: (BuildContext context) => MainScreen()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Response")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          child: (_isLoading)
              ? AlertDialog(
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
                  ))
              : Center(
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
                              question.question,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      new Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                          child: Column(children: <Widget>[
                            new ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              title: new TextFormField(
                                controller: _responseController,
                                decoration: new InputDecoration(
                                    hintText: "Write your response here",
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(),
                                    )),
                                maxLines: null,
                                minLines: 5,
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ),
                            (_image == null)
                                ? Column(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: getImageByCamera,
                                        child: new Text('Capture Image'),
                                      ),
                                      RaisedButton(
                                        onPressed: getImageByGallery,
                                        child: new Text('Select Image'),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: clearImage,
                                        child: new Text('Deselect Image'),
                                      ),
                                      RaisedButton(
                                        onPressed: () =>
                                            uploadFileFromDio(context),
                                        child: new Text('Submit response'),
                                      )
                                    ],
                                  )
                          ]),
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
