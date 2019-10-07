import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_reminder/model/note.dart';

class DatabaseHelper {
  //Singleton dbhelper
  static DatabaseHelper _dbHelper;
  static Database _db;

  String noteTable = "note_table";
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = "priority";
  String colDate = "date";

  //named constructor to crate instance of dbhelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_dbHelper == null) {
      _dbHelper = new DatabaseHelper._createInstance();
    }
    return _dbHelper;
  }

  Future<Database> initializeDatabase() async {
    //get the directory path for android and IoS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = directory.path + 'notes.db';

    //open, create the database to given path
    var db = await openDatabase(dbPath, version: 1, onCreate: _createDB);
    return db;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  Future<Database> get database async {
    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result =
        db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC");
    //SAME AS ABOVE
    //var result = db.query(noteTable, orderBy: '$colPriority ASC')
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(this.noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> num =
        await db.rawQuery("SELECT COUNT(*) FROM $noteTable");
    int result = Sqflite.firstIntValue(num);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapLIst = await getNoteMapList();
    int count = noteMapLIst.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMap(noteMapLIst[i]));
    }
    return noteList;
  }
}
