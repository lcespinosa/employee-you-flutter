class Department {
  int id;
  String name;
  String code;
  String description;

  Department({
    this.id,
    this.name,
    this.code,
    this.description,
  });

  Department.fromJson(Map<String, dynamic> json) {
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