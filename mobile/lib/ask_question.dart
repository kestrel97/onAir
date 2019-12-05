import 'package:OnAir/questions_list.dart';
import 'package:OnAir/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class AskQuestion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AskQuestionState();
  }
}

class AskQuestionState extends State<AskQuestion> {
  List<LatLng> _tappedPoints = [];
  final MapController _mapController = new MapController();
  bool _isLocationSelected = false;
  String _locationLocality;
  final TextEditingController _questionController = new TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    getCurrentLocation().then((pos) {
      _mapController.move(PositionToLatLng(pos), _mapController.zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = _tappedPoints.map((latlng) {
      return Marker(
        width: 30.0,
        height: 30.0,
        point: latlng,
        builder: (ctx) => Container(
              child: Image.asset('assets/pinpoint.png'),
            ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Ask Question")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (_isLoading)
            ? AlertDialog(
                title: new Text("Submitting"),
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
            : (_isLocationSelected)
                ? Column(
                    children: <Widget>[
                      (_locationLocality != null)
                          ? Text("Selected location: " + _locationLocality)
                          : null,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: new TextFormField(
                            controller: _questionController,
                            decoration: new InputDecoration(
                                hintText: "Write your query here",
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                )),
                            maxLines: null,
                            minLines: 5,
                            style: new TextStyle(
                                fontSize: 16.0,
                                // height: 2.0,
                                color: Colors.white),
//                contentPadding: const EdgeInsets.symmetric(vertical: 40.0),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: (() {
                          _submitQuestion();
                        }),
                        child: Text("Ask question"),
                      )
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text('Tap to select the location'),
                        ),
                        Flexible(
                            child: Stack(
                          children: <Widget>[
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                  center: LatLng(24.856897, 67.264683),
                                  zoom: 18.0,
                                  onTap: _handleTap),
                              layers: [
                                TileLayerOptions(
                                  urlTemplate:
                                      'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=b6abbada1054474184e6fe0744a508e0',
                                ),
                                MarkerLayerOptions(markers: markers)
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: (!_isLocationSelected && _tappedPoints.length != 0)
            ? new FloatingActionButton.extended(
//              backgroundColor: Colors.blue,
                onPressed: (() {
                  setState(() {
                    _isLocationSelected = true;
                  });
                }),
                icon: Icon(Icons.location_on),
                label: Text("Select Location"),
              )
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _handleTap(LatLng latlng) async {
    getLocality(latlng).then((locality) {
      setState(() {
        _locationLocality = locality;
        _tappedPoints.length == 0
            ? _tappedPoints.add(latlng)
            : _tappedPoints[0] = latlng;
      });
    });
  }

  void _submitQuestion() async {
    setState(() {
      _isLoading = true;
    });

    var response =
        await submitQuestion(_questionController.text, _tappedPoints.first);

    setState(() {
      _isLoading = false;
    });

    if (!response.data["success"]) {
      print("Question not created");
    } else {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) =>
              QuestionsList(title: "My questions", my_questions: true)));
    }
  }
}
