import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({Key? key}) : super(key: key);

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  String _profilePicUrl = "";
  String _username = "";
  String _fullName = "";
  String _feeling = "";
  List<String> _interests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: _profilePicUrl,
            placeholder: (context, url) => Image(image: AssetImage('assets/default.jpg'), width: 50, height: 50,),
          ),
          Row(
            children: <Widget>[
              Text(_username),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {

                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(_feeling),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {

                },
              ),
            ],
          ),
          Text("Full Name:"),
          Row(
            children: <Widget>[
              Text(_fullName),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {

                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("Interests:\n${_interests.join("\n")}"),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {

                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}
