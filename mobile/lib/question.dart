import 'package:geolocator/geolocator.dart';
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
  List<LatLng> tappedPoints = [];
  LatLng pos = new LatLng(24.856897, 67.264683);
  final MapController mapController = new MapController();

  @override
  void initState() {
    super.initState();

    _getCurrentLocation().then((pos) {
      mapController.move(pos, mapController.zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = tappedPoints.map((latlng) {
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
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text('Tap to add pins'),
                ),
                Flexible(
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        center: pos,
                        zoom: 18.0,
                        onTap: _handleTap),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                        'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=b6abbada1054474184e6fe0744a508e0',
                      ),
                      MarkerLayerOptions(markers: markers)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Future<LatLng> _getCurrentLocation() async {
    print("inside function");
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      tappedPoints.length == 0 ? tappedPoints.add(latlng) : tappedPoints[0] = latlng;
    });
  }
}
