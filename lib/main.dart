import 'package:date_app/pages/main_page.dart';
import 'package:flutter/material.dart';

import 'helpers/sharedPrefs.dart';
import 'pages/register_and_login/login.dart';


void main() {
  runApp(MyApp());
}


String _token = "";


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getFromPrefs("login_token").then((String value) {
      _token = value;
    });
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,

      title: 'Dating App',
      home: _token.isNotEmpty ? MainPage(key: null, token: _token) : LoginPage(key: null,),
    );
  }
}

