import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_reminder/model/note.dart';
import 'package:note_reminder/utils/db_helper.dart';

class NoteDetail extends StatefulWidget {
  final String title;
  Note note;

  NoteDetail({this.note, this.title});

  @override
  _NoteDetailState createState() => _NoteDetailState(this.note);
}

class _NoteDetailState extends State<NoteDetail> {
  Note note;
  static var _priorities = ['Hight', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper dbHelper = DatabaseHelper();

  _NoteDetailState(this.note);

  @override
  Widget build(BuildContext context) {
    TextStyle txtStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String p) {
                  return DropdownMenuItem<String>(
                    child: Text(p),
                    value: p,
                  );
                }).toList(),
                style: txtStyle,
                value: getPriorityValue(note.priority),
                onChanged: (value) {
                  setState(() {
                    setPriorityValue(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: txtStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                controller: titleController,
                style: txtStyle,
                onChanged: (value) {
                  note.title = titleController.text;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: txtStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                controller: descriptionController,
                style: txtStyle,
                onChanged: (value) {
                  note.description = descriptionController.text;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "Save",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "Delete",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void setPriorityValue(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityValue(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void _showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    Navigator.pop(context, true);
    if (note.id == null) {
      _showAlertDialog("Status", "No note was deleted");
      return;
    }
    await dbHelper.deleteNote(note.id);
  }

  void _save() async {
    Navigator.pop(context, true);
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await dbHelper.updateNote(note);
    } else {
      result = await dbHelper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Noe saved successfully');
    } else {
      _showAlertDialog('Status', 'Error, not saved');
    }
  }
}
