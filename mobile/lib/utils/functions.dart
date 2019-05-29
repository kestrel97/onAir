import 'dart:convert';

import 'package:OnAir/models/response.dart';
import 'package:OnAir/models/question.dart';
import 'package:OnAir/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'package:dio/dio.dart';

void postAuthentication(String name, String uid, String identifier) async {
  await saveFirebaseUser(name, uid, identifier);
  LatLng location = PositionToLatLng(await getCurrentLocation());
  String fcm_token = await readFcmToken();
  await updateUser(User(
      name: name,
      uid: uid,
      identifier: identifier,
      fcm_token: fcm_token,
      location: location));
}

Position LatLngToPosition(LatLng latlng) {
  return Position(longitude: latlng.longitude, latitude: latlng.latitude);
}

LatLng PositionToLatLng(Position position) {
  return LatLng(position.latitude, position.longitude);
}

Future<Position> getCurrentLocation() async {
  return await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

void saveFirebaseUser(String name, String uid, String identifier) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(KEY_FIREBASE_UID, uid);
  prefs.setString(KEY_IDENTIFIER, identifier);
  if (name != null) prefs.setString(KEY_USER_NAME, name);
}

Future<String> getUid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(KEY_FIREBASE_UID);
}

void updateUser(User user) async {
  const String endPoint = BASE_END_POINT + "/api/users/update";
  var response = await Dio().post(endPoint, data: user.toJson());
}

void saveFcmToken(String fcm_token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(KEY_FCM_TOKEN, fcm_token);
}

Future<String> readFcmToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(KEY_FCM_TOKEN);
}

Future<String> getLocality(LatLng latlng) async {
  List<Placemark> placemark =
      await Geolocator().placemarkFromPosition(await LatLngToPosition(latlng));
  return placemark.first.name +
      " " +
      placemark.first.locality +
      " " +
      placemark.first.subLocality +
      " " +
      placemark.first.subAdministrativeArea;
}

Future<Response> submitQuestion(String question, LatLng location) async {
  String uid = await getUid();
  Question questionObj =
      Question(user: uid, location: location, question: question);
  return await Dio().post(BASE_END_POINT + "/api/questions/create",
      data: questionObj.toJson());
}

Future<List<Question>> getQuestionsByUserId() async {
  String uid = await getUid();
  var response =
      await Dio().get(BASE_END_POINT + "/api/questions/byUid/" + uid);
  List<dynamic> list = response.data;
  List<Question> questions =
      list.map((model) => Question.fromJson(model)).toList();
  return questions;
}

Future<List<Question>> getRequestsByUserId() async {
  String uid = await getUid();
  var response = await Dio().get(BASE_END_POINT + "/api/requests/byUid/" + uid);
  List<dynamic> list = response.data;
  List<Question> questions =
      list.map((model) => Question.fromJson(model)).toList();
  return questions;
}

Future<QuestionResponse> getResponseByQuestionId(question_id) async {
  var response;
  try {
    response = await Dio()
        .get(BASE_END_POINT + "/api/responses/byQuestionId/" + question_id);
  } on DioError catch (e) {
    return new QuestionResponse();
  }
  return QuestionResponse.fromJson(response.data);
}
