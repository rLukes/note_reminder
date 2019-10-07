class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //[this._description] is optional
  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get date => _date;

  int get priority => _priority;

  set title(String title) {
    if (title.length <= 255) {
      this._title = title;
    }
  }

  set description(String desc) {
    if (desc.length <= 255) {
      this._description = desc;
    }
  }

  set priority(int priority) {
    if (priority >= 1 && priority <= 2) {
      this._priority = priority;
    }
  }

  set date(String date) {
    this._date = date;
  }

  //convert a note object into map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}
