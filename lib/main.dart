import 'package:flutter/material.dart';
import 'package:note_reminder/note_detail.dart';
import 'package:note_reminder/screens/note_list.dart';

void main() => runApp(NoteReminder());

class NoteReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note Reminder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: Center(
        child: NoteDetail()
      ),
    );
  }
}
