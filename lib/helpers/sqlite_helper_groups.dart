import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_app/objectsAndWidgets/objects.dart';
import 'package:flutter/widgets.dart';


Future<Database> initializeDb() async {
  // WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'chat_database.db'),

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE groups(group_id INTEGER PRIMARY KEY, group_name TEXT, picture_url TEXT, unread_messages INTEGER, last_message_id INTEGER, last_message_creator TEXT)'
      );
    },
    version: 1,
  );
  return await database;
}


Future<void> insertGroup(GroupItemObject group) async {
  final db = await initializeDb();

  await db.insert(
      "groups",
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
  );
}


Future<List<GroupItemObject>> getGroups() async {
  // Get a reference to the database.
  final db = await initializeDb();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('groups');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return GroupItemObject(
        groupId: maps[i]['group_id'],
        groupName: maps[i]['group_name'],
        lastMessageCreator: maps[i]['creator'],
        lastMessageId: maps[i]['id'],
        pictureUrl: maps[i]['pic_url'],
        unreadMessages: maps[i]['unreadMessages']
    );
  });
}


Future<void> updateGroup(GroupItemObject group) async {
  final db = await initializeDb();

  await db.update(
    "groups",
    group.toMap(),
    where: 'group_id = ?',
    whereArgs: [group.groupId]
  );
}


Future<void> deleteGroup(GroupItemObject group) async {
  final db = await initializeDb();

  await db.update(
    "groups",
    group.toMap(),
    where: 'group_id = ?',
    whereArgs: [group.groupId]
  );
}