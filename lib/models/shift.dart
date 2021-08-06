class Shift {
  int id;
  String name;
  String code;
  String description;

  Shift({
    this.id,
    this.name,
    this.code,
    this.description,
  });

  Shift.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      id = json['id'];
      name = json['name'];
      code = json['code'];
      description = json['description'];
    }
  }

  String get Name {
    if (name.isEmpty) {
      return '-';
    }
    return name;
  }
}