import 'package:date_app/pages/register_and_login/username_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';


class BirthDatePage extends StatefulWidget {
  const BirthDatePage({Key? key, required this.fullName}) : super(key: key);
  final String fullName;
  @override
  _BirthDatePageState createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  DateTime _dob = DateTime(2000, 1, 1);
  bool _changed = false;

  _selectDate(BuildContext context) async {
    DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _dob, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 13, 1, 1),
    ))!;
    setState(() {
      _dob = picked;
      _changed = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick your birthday"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Birthday", style: TextStyle(color: Colors.grey[600]),),
              SizedBox(height: 2,),

              Platform.isIOS ? Container(
                height: 200,
                child:  CupertinoDatePicker(
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year - 13,
                  initialDateTime: DateTime(2000, 1, 1),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime val) {
                    setState(() {
                      _changed = true;
                      _dob = val;
                    });
                  },
                ),
              ): Container(child: Column(children: <Widget>[
                SizedBox(height: 50,),
                Text("${_dob.year}-${_dob.month}-${_dob.day}"),
                ElevatedButton(onPressed: () => _selectDate(context), child: Text("Choose Birthday"),),
                SizedBox(height: 20,),
              ],),),
              Text("*You cannot change this in the future", style: TextStyle(color: Colors.grey),),
              SizedBox(height: 40,),
              ButtonTheme(
                minWidth: 60.0,
                height: 20.0,
                child: ElevatedButton(
                  onPressed: _changed ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserNamePickerPage(key: null, fullName: widget.fullName, dob: _dob)),
                    );
                  } : null,
                  child: Text("Continue"),
                  style: ElevatedButton.styleFrom(
                    primary: _changed ? Colors.pink : Colors.grey,
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
