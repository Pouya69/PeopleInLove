import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:flutter/material.dart';


class GroupListItem extends StatelessWidget {
  const GroupListItem({Key? key, required this.listDetails}) : super(key: key);
  final ItemObject listDetails;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(listDetails.groupName),
          Row(
            children: <Widget>[
            ],
          ),
        ],
      ),
    );
  }
}
