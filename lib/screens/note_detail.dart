import 'package:flutter/material.dart';
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
                value: 'Low',
                onChanged: (value) {
                  setState(() {});
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
                onChanged: (value) {},
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
                onChanged: (value) {},
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
                        setState(() {});
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
                        setState(() {});
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

  void getPriorityValue(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }
}
