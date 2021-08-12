import 'package:date_app/api/api_register_login.dart';
import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:date_app/pages/register_and_login/register.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../main_page.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = true;
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
        title: Text("Login"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
            padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 210.0,
                height: 70.0,
                child: TextFormField(
                  controller: _usernameController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Username or Email",
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 40.0,),
                  Container(
                    width: 210.0,
                    height: 70.0,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: new InputDecoration(
                        fillColor: Colors.grey[200],
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      child: _hidePassword ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye, color: Colors.blue,),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              ButtonTheme(
                minWidth: 60.0,
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
                  child: Text("Let's Go!"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    textStyle: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account?"),
                  TextButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NamePage(key: null,)),
                    );
                  }, child: Text("Create an account"),)
                ],
              ),
              FutureBuilder<LoginObject>(
                  future: _futureLogin,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String t = snapshot.data!.token;
                      if(t.isNotEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage(key: null, token: t,)),
                        );
                      }
                    }
                    else if (snapshot.hasError) {
                      //TODO: Check verify
                      // String result = "${snapshot.error}".substring(1, "${snapshot.error}".indexOf(':'));
                      return Row(children: <Widget>[
                        Icon(Icons.error, color: Colors.red[700], size: 5.0,),
                        Text("${snapshot.error}")
                      ],);
                    }
                    return Text("");
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


