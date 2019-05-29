import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong/latlong.dart';

class User {
  String name;
  String uid;
  String identifier;
  String fcm_token;
  LatLng location;

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'identifier': identifier,
        'fcm_token': fcm_token,
        'location': {
          'coordinates': [
            location.longitude.toString(),
            location.latitude.toString()
          ]
        }
      };

  User({this.name, this.uid, this.identifier, this.fcm_token, this.location});

  User.fromFirebaseUser(FirebaseUser user, String fcm_token, LatLng location)
      : name = (user.providerData[0].displayName != null)
            ? user.providerData[0].displayName
            : "",
        uid = user.uid,
        identifier = (user.providerData[0].email != null)
            ? user.providerData[0].email
            : user.providerData[0].phoneNumber,
        fcm_token = fcm_token,
        location = location;
}
