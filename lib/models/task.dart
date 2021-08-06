class Task {
  int id;
  String title;
  String description;
  bool opened;
  String notes;
  int total_time;
  int estimated_hours;
  String status;
  DateTime status_time;
  String status_notes;

  int projectId;

  Task({
    this.id,
    this.title,
    this.description,
    this.opened,
    this.notes,
    this.total_time,
    this.estimated_hours,
    this.status,
    this.status_time,
    this.status_notes,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id              = json['id'];
    projectId       = json['project_id'];
    title           = json['title'];
    description     = json['description'];
    opened          = json['opened'];
    notes           = json['notes'];
    total_time      = json['total_time'];
    estimated_hours = json['estimated_hours'];
    status          = json['status'];
    status_time     = json['status_time'];
    status_notes    = json['status_notes'];
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