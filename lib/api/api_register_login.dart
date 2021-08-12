import 'dart:async';
import 'dart:convert';

import 'package:date_app/helpers/sharedPrefs.dart';
import 'package:http/http.dart' as http;

import '../objectsAndWidgets/objects.dart';

final String messageUrl = "ws://192.168.0.47:8000/messages/";
final String siteUrl = "http://192.168.0.47:8000";


Future<String> registerRequest(String username, String email, String dob, String gender, String password) async {
  final response = await http.post(
      Uri.parse(siteUrl + "/api/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'gender': gender,
        'date_of_birth': dob,
        'password': password,
      })
  );
  Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return "OK";
  } else if(response.statusCode == 402) {
    throw Exception("Invalid characters in username. Allowed characters : A-Z 0-9 _");
  } else if(response.statusCode == 405) {
    throw Exception("Invalid characters in email");
  } else if(response.statusCode == 500) {
    throw Exception("Unexpected Error");
  }
  throw Exception("$jsonResponse");
}


Future<String> usernameRequest(String username) async {
  print(username);
  try {
    final response = await http.post(
        Uri.parse(siteUrl + "/api/usernameCheck"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
        })
    ).timeout(const Duration(seconds: 3));
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "Username available";
    } else if(response.statusCode == 404) {
      throw Exception("Username already taken");
    } else if(response.statusCode == 402) {
      throw Exception("Invalid characters in username. a-z 0-9 _");
    }
    throw Exception("${jsonResponse['status']}");
  } on TimeoutException catch(_) {
    throw Exception("Username already taken");
  }
}


Future<int> verifyAgainRequest(String email) async {
  final response = await http.post(
      Uri.parse(siteUrl + "/api/verifyAgain"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      })
  );
  Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return 200;
  } else if(response.statusCode == 401) {
    // Already verified
    return 401;
  }
  throw Exception("$jsonResponse");
}


Future<LoginObject> loginRequest(String username, String password) async {
  final response = await http.post(
      Uri.parse(siteUrl + "/api/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: username.contains("@") ? jsonEncode(<String, String>{
        'email': username,
        'password': password,
      }) : jsonEncode(<String, String>{
        'username': username,
        'password': password,
      })
  );
  if (response.statusCode == 200) {
    // Save the data to SQLite
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    String token = jsonResponse["token"];
    addToPrefs("login_token", token);
    addToPrefs("account_type", jsonResponse["user"]["account_type"]);
    addToPrefs("password", password);
    addToPrefs("email", jsonResponse["user"]["email"]);
    addToPrefs("username", jsonResponse["user"]["username"]);
    addToPrefs("date_of_birth", jsonResponse["user"]["date_of_birth"]);
    addToPrefs("full_name", jsonResponse["user"]["full_name"]);
    addToPrefs("gender", jsonResponse["user"]["gender"]);
    addToPrefs("feeling", jsonResponse["user"]["feeling"]);
    addToPrefsList("interests", jsonResponse["user"]["interests"]);
    return LoginObject.fromJSON(token, jsonResponse["user"]);
  } else if(response.statusCode == 405) {
    throw Exception("Not Verified");
    // Not verified
  } else if(response.statusCode == 404 || response.statusCode == 403) {
    // Password Error
    throw Exception("Your password is incorrect");
  } else if(response.statusCode == 406) {
    // Username or Email not found
    throw Exception("Username or email is invalid");
  } else if(response.statusCode == 500) {
    throw Exception("Unexpected Error");
  }
  throw Exception("Unexpected Error");
}


