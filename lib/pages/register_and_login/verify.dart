import 'package:date_app/api/api_register_login.dart';
import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// mport 'package:intl/intl.dart';

import '../main_page.dart';
// import 'dart:io' show Platform;


class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key, required this.email, required this.password}) : super(key: key);
  final String email;
  final String password;

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  Future<LoginObject>? _futureLogin;
  Future<int>? _futureVerifyAgain;
  String _buttonText = "Send me another email";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify your account"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("We sent you an email to ${widget.email}"),
              Text("Follow the instructions on the email to complete your account creation"),
              Text("Once done, click the button below :"),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureLogin = loginRequest(widget.email, widget.password);
                  });
                },
                child: Text("Already verified"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureVerifyAgain = verifyAgainRequest(widget.email);
                  });
                },
                child: Text("$_buttonText"),
              ),
              FutureBuilder<LoginObject>(
                future: _futureLogin,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage(key: null, token: snapshot.data!.token,)),
                    );
                  } else if(snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Text("");
                },
              ),
              FutureBuilder(
                future: _futureVerifyAgain,
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if(snapshot.hasData) {
                    if(snapshot.data! == 200) {
                      setState(() {
                        _buttonText = "Email sent again";
                      });
                    } else {
                      setState(() {
                        _futureLogin = loginRequest(widget.email, widget.password);
                      });
                    }
                  }
                  return Text("Check your spam folder if you cannot see our email");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
