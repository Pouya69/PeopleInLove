import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/api/api_user_info.dart';
import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:date_app/helpers/sqlite_helper_messages.dart' as msgDbHelper;


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.group, required this.token}) : super(key: key);
  final GroupItemObject group;
  final String token;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageObject> _messages = [];
  WebSocketChannel? channel;
  Future<Database>? database;

  @override
  void initState() {
    // TODO: implement initState
    database = msgDbHelper.initializeDb();
    msgDbHelper.getMessagesByGroupID(widget.group.groupId, database!).then((List<MessageObject> value) {
      _messages = value;
    });

    channel = IOWebSocketChannel.connect(
        "$messageUrl/${widget.group.groupId}",
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ${widget.token}'
        }
    );
    channel!.stream.listen((event) {
      Map<String, dynamic> jsonEvent = jsonDecode(event);
      print("Event : $jsonEvent");


    });

    channel!.sink.add({'command': "fetch_messages"});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      channel!.sink.close();
    } catch(_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: CachedNetworkImage(
                    imageUrl: widget.group.pictureUrl,
                    placeholder: (context, url) => Image(
                      image: AssetImage('assets/group_default.jpg'),
                    )
                ),
                onPressed: () {

                },
            ),
            Text(widget.group.groupName),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Image(image: AssetImage('assets/info.png'),),
            onPressed: () {

            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {

                },
              );
            },
            reverse: true,
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {

                  },
              ),
              TextFormField(),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {

                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
