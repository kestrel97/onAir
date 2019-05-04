import 'package:latlong/latlong.dart';

class Question {
  String user;
  String question;
  LatLng location;

  Question({this.user, this.question, this.location});

  Map<String, dynamic> toJson() =>
      {
        'user': user,
        'question': question,
        'location': {
          'coordinates': [ location.longitude.toString(), location.latitude.toString() ]
        }
      };

  factory Question.fromJson(Map<String, dynamic> parsedJson){
    return Question(
        user: parsedJson['user'],
        question : parsedJson['question'],
        location : parsedJson['location']['coordinates']
    );
  }
}