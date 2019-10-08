import 'package:flutter/material.dart';
import 'package:note_reminder/screens/note_detail.dart';
import 'package:note_reminder/model/note.dart';
import 'package:note_reminder/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList != null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Note Reminder'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          navigateToDetail(Note('','',2), 'Add Note');
        },
      ),
    );
  }

  getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        Note currentNote = this.noteList[index];
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(currentNote.priority),
              child: getPriorityIcon(currentNote.priority),
            ),
            title: Text(
              currentNote.title,
              style: titleStyle,
            ),
            subtitle: Text(currentNote.date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                _deleteNote(context, currentNote);
              },
            ),
            onTap: () {
              navigateToDetail(currentNote, 'Edit Note');
            },
          ),
        );
      },
      itemCount: count,
    );
  }

  Color getPriorityColor(int p) {
    switch (p) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.green;
        break;

      default:
        return Colors.green;
    }
  }

  Icon getPriorityIcon(int p) {
    switch (p) {
      case 1:
        return Icon(Icons.play_arrow);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _deleteNote(BuildContext ctx, Note note) async {
    int result = await this.dbHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(ctx, 'Note deleted');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext ctx, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    Scaffold.of(ctx).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note: note,
        title: title,
      );
    }));
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((db) {
      Future<List<Note>> noteListFuture = dbHelper.getNoteList();
      noteListFuture.then((list) {
        setState(() {
          this.noteList = list;
          this.count = noteList.length;
        });
      });
    });
  }
}
