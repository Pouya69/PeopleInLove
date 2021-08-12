import 'dart:async';
import 'package:date_app/api/api_user_info.dart';
import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.groupId}) : super(key: key);
  final int groupId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${widget.groupId}"),
      ),
    );
  }
}
