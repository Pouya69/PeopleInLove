import 'package:date_app/api/api_register_login.dart';
import 'package:date_app/pages/register_and_login/login.dart';
import 'package:date_app/pages/register_and_login/verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'birthday_page.dart';


class NamePage extends StatefulWidget {
  const NamePage({Key? key}) : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  String _firstName = "";
  String _lastName = "";
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's start with your name"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("What's your name?"),
              SizedBox(height: 30,),
              Container(
                width: 210.0,
                height: 80.0,
                child: TextFormField(
                  // controller: _firstNameController,
                  onChanged: (String value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Container(
                width: 210.0,
                height: 80.0,
                child: TextFormField(
                  onChanged: (String value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                  // controller: _lastNameController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    labelText: "Last Name",
                  ),
                ),
              ),
              SizedBox(height: 40,),
              ButtonTheme(
                minWidth: 100.0,
                height: 20.0,
                child: ElevatedButton(
                  onPressed: _firstName.isNotEmpty && _lastName.isNotEmpty ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BirthDatePage(key: null, fullName: "$_firstName $_lastName",)),
                      );
                  } : null,
                  child: Text("Continue"),
                  style: ElevatedButton.styleFrom(
                    primary: _firstName.isNotEmpty && _lastName.isNotEmpty ? Colors.pink : Colors.grey,
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


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.fullName, required this.dob, required this.username}) : super(key: key);
  final String fullName;
  final String username;
  final DateTime dob;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  int _gender = -1;
  String email = "";
  String password = "";
  bool _hidePassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<String>? _futureRegister;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 210.0,
                height: 70.0,
                child: TextFormField(
                  controller: _emailController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                    prefixText: ' ',
                    labelText: "Email",
                  ),
                ),
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
                      autocorrect: false,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                        prefixText: ' ',
                        labelText: "Password",
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(value: 0, groupValue: _gender, onChanged: (int? value) {
                    setState(() {
                      _gender = value!;
                    });
                  },),
                  Text("Male"),
                  Radio(value: 1, groupValue: _gender, onChanged: (int? value) {
                    setState(() {
                      _gender = value!;
                    });
                  },),
                  Text("Female"),
                  Radio(value: 2, groupValue: _gender, onChanged: (int? value) {
                    setState(() {
                      _gender = value!;
                    });
                  },),
                  Text("Other"),
                ],
              ),
              ButtonTheme(
                minWidth: 60.0,
                height: 20.0,
                child: ElevatedButton(
                  onPressed: () {
                    if(password.isNotEmpty && email.isNotEmpty && _gender != -1) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(widget.dob);
                      setState(() {
                        password = _passwordController.text.toString();
                        email = _emailController.text.toString();
                        _futureRegister = registerRequest(widget.username, email, formattedDate, _gender == 0 ? "male" : (_gender == 1 ? "female" : "other"), password);
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
              FutureBuilder(
                future: _futureRegister,
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyPage(key: null, email: email, password: password,)),
                  );
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Text("");
              },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  TextButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage(key: null,)),
                    );
                  }, child: Text("Login!"),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
