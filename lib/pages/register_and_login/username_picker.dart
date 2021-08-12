import 'package:date_app/api/api_register_login.dart';
import 'package:date_app/pages/register_and_login/register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// mport 'package:intl/intl.dart';


class UserNamePickerPage extends StatefulWidget {
  const UserNamePickerPage({Key? key, required this.fullName, required this.dob}) : super(key: key);
  final String fullName;
  final DateTime dob;
  @override
  _UserNamePickerPageState createState() => _UserNamePickerPageState();
}

class _UserNamePickerPageState extends State<UserNamePickerPage> {
  TextEditingController _usernameController = TextEditingController();
  String _error = "";
  bool _done = true;
  String _username = "";
  bool _ok2 = false;
  RegExp allowedCharacters = RegExp(r'^[a-z0-9_]*$');
  Future<String>? _futureUsername;

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 210.0,
                height: 70.0,
                child: TextFormField(
                  controller: _usernameController,
                  autocorrect: false,
                  enabled: _done,
                  onChanged: (String value) {
                    value = value.toLowerCase();
                    if(value.length >= 5) {
                      setState(() {
                        _error = "";
                      });
                      if(!allowedCharacters.hasMatch(value)) {
                        setState(() {
                          _error = "Invalid characters in username. a-z 0-9 _";
                          _ok2 = false;
                        });
                      }
                      else {
                        setState(() {
                          _ok2 = true;
                        });
                      }
                    } else {
                      setState(() {
                        _ok2 = false;
                        _error = "Username needs to be at least 5 characters long";
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.person, color: Colors.blueAccent,),
                    prefixText: ' ',
                  ),
                ),
              ),
              SizedBox(height: 10,),
              FutureBuilder<String>(
                future: _futureUsername,
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    _username = "";
                    return Text("${snapshot.error}");
                  }
                  else if(snapshot.hasData) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage(key: null, fullName: widget.fullName, dob: widget.dob, username: _username,)),
                      );
                    });
                  }
                  return Text("$_error");
                },
              ),
              ButtonTheme(
                minWidth: 60.0,
                height: 20.0,
                child: ElevatedButton(
                  onPressed: _ok2 ? () {
                    setState(() {
                      _username = _usernameController.text.toString().toLowerCase();
                      _futureUsername = usernameRequest(_username);
                    });
                  } : null,
                  child: Text("Continue"),
                  style: ElevatedButton.styleFrom(
                    primary: _ok2 ? Colors.pink : Colors.grey,
                    textStyle: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
