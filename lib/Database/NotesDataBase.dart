import 'package:flutter/cupertino.dart';
import 'package:newsqlproject/models/NotesModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class NotesDatabase {
  NotesDatabase._privateConstructor();
  static final NotesDatabase instance = NotesDatabase._privateConstructor();
  static Database? database;
  Future<Database> get notesdatabase async {
    if (database != null) {
      return database!;
    }
    database = await initDatabase();
    return database!;
  }

  initDatabase() async {
    try {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "USERDATABASE.db");
      var db = await openDatabase(path, version: 1, onCreate: oncreate);
      return db;
    } catch (e) {
      print(e.toString());
    }
  }

  oncreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE NOTES(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,description TEXT, time TEXT )");
  }

  Future<List<NotesModal>> getUsers() async {
    Database db = await instance.initDatabase();
    var users = await db.query('NOTES', orderBy: 'title');
    List<NotesModal> userlist = await users.isNotEmpty
        ? users.map((e) => NotesModal.fromMap(e)).toList()
        : [];
    return userlist;
  }

  Future<int> insert(NotesModal notesModal) async {
    Database db = await instance.initDatabase();
    return await db.insert('NOTES', notesModal.toMap());
  }

  Future<int> delete(NotesModal notesModal) async {
    Database db = await instance.initDatabase();
    return await db.delete('NOTES', where: 'id =?', whereArgs: [notesModal.id]);
  }

  Future<int> update(NotesModal notesModal) async {
    Database db = await instance.initDatabase();
    return await db.update('NOTES', notesModal.toMap(),
        where: 'id=?', whereArgs: [notesModal.id]);
  }
}
