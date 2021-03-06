import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/api/api_user_info.dart';
import 'package:date_app/helpers/sqlite_helper_groups.dart' as dbHelper;
import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:date_app/objectsAndWidgets/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'chat_and_utils/chat_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  WebSocketChannel? channel;
  List<GroupItemObject> _groups = [];
  List<int> _groupIds = [];
  Future<String>? _futureFeeling;

  _goToChatScreen(GroupItemObject group, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(key: null, group: group, token: widget.token,)),);
  }

  @override
  void initState() {
    // Load chats from db
    dbHelper.getGroups().then((List<GroupItemObject> value) {
      _groups = value;
    });

    // TODO: implement initState
    channel = IOWebSocketChannel.connect(
        groupFetchUrl,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ${widget.token}'
        }
    );

    channel!.stream.listen((event) {
      Map<String, dynamic> jsonEvent = jsonDecode(event);
      print("Event : $jsonEvent");

      for(Map<String, dynamic> groupJson in jsonEvent["groups"]) {
        List<String> _keys = groupJson.keys.toList();
        GroupItemObject group = GroupItemObject.fromJSON(groupJson[_keys[0]], groupJson[_keys[0]]["unread_messages"]);
        if(!_groupIds.contains(group.groupId)) {
          dbHelper.insertGroup(group);
          setState(() {
            _groups.add(group);
            _groupIds.add(group.groupId);
          });
        } else {
          int i = _groupIds.indexOf(group.groupId);
          if(_groups[i].lastMessageId != group.lastMessageId) {
            dbHelper.updateGroup(group);
            setState(() {
              _groupIds.removeAt(i);
              _groups.removeAt(i);
              _groups.insert(0, group);
              _groupIds.insert(0, group.groupId);
            });
          }
        }
      }
    });
    var mapData = {
      "command": "fetch_group_live",
    };
    channel!.sink.add(mapData);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      appBar: AppBar(
        title: Text("Dating App"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: _groupIds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: _groups[index].pictureUrl,
                      placeholder: (context, url) => Image(image: AssetImage('assets/default.jpg'), width: 15, height: 15,),
                    ),  // Check here
                    title: Text(_groups[index].groupName),
                    subtitle: Text("From ${_groups[index].lastMessageCreator}"),
                    trailing: FutureBuilder(
                      future: _futureFeeling,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return getFeeling("${snapshot.data}");
                        } else if(snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Text("---");
                      },
                    ),
                    onTap: () => _goToChatScreen(_groups[index], context),
                    onLongPress: () {

                    },
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
