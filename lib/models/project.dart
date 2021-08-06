import 'package:starterkit/models/task.dart';

class Project {
  int id;
  String title;
  String description;
  bool opened;
  String notes;
  int total_time;
  String status;
  DateTime status_time;
  String status_notes;
  List<Task> tasks;

  Project({
    this.id,
    this.title,
    this.description,
    this.opened,
    this.notes,
    this.total_time,
    this.status,
    this.status_time,
    this.status_notes,
    this.tasks = const []
  });

  Project.fromJson(Map<String, dynamic> json) {
    id          = json['id'];
    title       = json['title'];
    description = json['description'];
    opened      = json['opened'];
    notes       = json['notes'];
    total_time  = json['total_time'];
    status      = json['status'];
    status_time = json['status_time'];
    status_notes = json['status_notes'];

    List<Task> result = [];
    if (json['tasks'] != null) {
      json['tasks']['data'].forEach((t) {
        result.add(Task.fromJson(t));
      });
    }
    tasks = result;
  }

  //Dynamic values
  Map<String, dynamic> _toMap() {
    return {
      'name': title,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}