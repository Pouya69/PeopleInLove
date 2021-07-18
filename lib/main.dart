import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String siteUrl = "http://192.168.0.47:8000";

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
    return LoginObject.fromJSON(jsonDecode(response.body)["token"], jsonDecode(response.body)["user"]);
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
    throw Exception("500 Error");
  }
  throw Exception("Unexpected Error");
}

class LoginObject {
  final String token;
  final String email;
  final String dateOfBirth;
  final bool gender;
  final String username;
  final String about;
  final String datingWith;
  final String feeling;
  final List<dynamic> interests;
  final int premiumDaysLeft;
  final bool private;
  final String fullName;
  final String createDate;

  LoginObject({required this.token, required this.email, required this.dateOfBirth, required this.gender, required this.username, required this.about, required this.datingWith, required this.feeling, required this.interests, required this.premiumDaysLeft, required this.private, required this.fullName, required this.createDate});
  // LoginObject({required this.token});
  factory LoginObject.fromJSON(String token, Map<String, dynamic> userDetails) {
    return LoginObject(
      token: token,
      email: userDetails["email"],
      dateOfBirth: userDetails["date_of_birth"],
      username: userDetails["username"],
      about: userDetails["about"],
      datingWith: userDetails["dating_with"] != null ? userDetails["dating_with"] : "",
      fullName: userDetails["full_name"],
      gender: userDetails["gender"],
      feeling: userDetails["feeling"],
      interests: userDetails["interests"],
      private: userDetails["private"],
      createDate: userDetails["create_date"],
      premiumDaysLeft: userDetails["premium_days_left"],
    );
  }


}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Login', key: null,),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);


  final String title;


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<LoginObject>? _futureLogin;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// TODO: Sign up like SnapChat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the LoginPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 230.0,
              height: 80.0,
              child: TextFormField(
                controller: _usernameController,
                autocorrect: false,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Username or Email",
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                  ),
                  prefixText: ' ',
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 40,
                ),
                Container(
                  width: 230.0,
                  height: 80.0,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: hidePassword,
                    decoration: new InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.blueAccent,
                      ),
                      prefixText: ' ',
                    ),
                  ),
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    child: hidePassword ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye, color: Colors.blue,),
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 40,
            ),
            ButtonTheme(
              minWidth: 80.0,
              height: 20.0,
                child: ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text.toString().toLowerCase();
                    String password = _passwordController.text.toString();
                    if(username.isNotEmpty && password.isNotEmpty) {
                      setState(() {
                        _futureLogin = loginRequest(username, password);
                      });
                    }
                  },
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    textStyle: TextStyle(
                        color: Colors.white
                    ),
                  ),
              ),
            ),
            FutureBuilder<LoginObject>(
              future: _futureLogin,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.token);
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Text("Nothing");
            }),
          ],
        ),
      ),
    );
  }
}
