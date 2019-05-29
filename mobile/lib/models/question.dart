import 'package:latlong/latlong.dart';

class Question {
  String id;
  String user;
  String question;
  LatLng location;

  Question({this.id, this.user, this.question, this.location});

  Map<String, dynamic> toJson() =>
      {
        '_id': id,
        'user': user,
        'question': question,
        'location': {
          'coordinates': [ location.longitude.toString(), location.latitude.toString() ]
        }
      };

  factory Question.fromJson(Map<String, dynamic> parsedJson){
    return Question(
        id: parsedJson['_id'],
        user: parsedJson['user'],
        question : parsedJson['question'],
        location : (parsedJson['location'] != null) ? LatLng(parsedJson['location']['coordinates'][1], parsedJson['location']['coordinates'][0]) : null
    );
  }
}