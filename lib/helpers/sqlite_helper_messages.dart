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
          'CREATE TABLE messages(message_id INTEGER PRIMARY KEY, group_id INTEGER, creator TEXT, file_url TEXT, replying_to TEXT, content TEXT, created_at TEXT, is_read INTEGER)'
      );
    },
    version: 1,
  );
  return await database;
}


Future<void> insertMessage(MessageObject message, Future<Database> database) async {
  final db = await database;
  await db.insert(
      "messages",
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
  );
}


Future<List<MessageObject>> getMessagesByGroupID(int groupId, Future<Database> database) async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('groups');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return MessageObject(
        messageId: maps[i]["message_id"],
        groupId: maps[i]["group_id"],
        creator: maps[i]["creator"],
        replyingTo: maps[i]["replying_to"],
        fileUrl: maps[i]["file_url"],
        content: maps[i]["content"],
        timeStamp: maps[i]["created_at"],
        isRead: maps[i]["is_read"]
    );
  });
}


Future<void> updateMessage(MessageObject message, Future<Database> database) async {
  final db = await database;

  await db.update(
      "messages",
      message.toMap(),
      where: 'group_id = ?',
      whereArgs: [message.groupId]
  );
}


Future<void> deleteMessage(MessageObject message, Future<Database> database) async {
  final db = await database;

  await db.update(
      "messages",
      message.toMap(),
      where: 'group_id = ?',
      whereArgs: [message.groupId]
  );
}