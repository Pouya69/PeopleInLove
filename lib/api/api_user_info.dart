import 'dart:async';
import 'dart:convert';

import 'package:date_app/helpers/sharedPrefs.dart';
import 'package:http/http.dart' as http;

final String messageUrl = "ws://192.168.0.47:8000/messages";
final String groupFetchUrl = "ws://192.168.0.47:8000/groups";
final String siteUrl = "http://192.168.0.47:8000";


String _token = "";
String _tokenType = "";
_getToken() {
  getFromPrefs("account_type").then((String value) {
    _tokenType = value;
  });

  getFromPrefs("login_token").then((String value) {
    _token = value;
  });
}



Future<String> getFeelingStringRequest(String username) async {
  _getToken();
  final response = await http.get(
    username == "" ? Uri.parse(siteUrl + "/api/feeling") : Uri.parse(siteUrl + "/api/feeling/" + username),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "HTTP_AUTHORIZATION": _tokenType == "google" ? "Bearer $_token" : "token $_token"
    },
  );
  Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse['feeling'];
  }
  throw Exception("$jsonResponse");
}
