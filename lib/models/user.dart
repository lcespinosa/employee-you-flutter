import 'package:starterkit/models/department.dart';
import 'package:starterkit/models/group.dart';
import 'package:starterkit/models/shift.dart';

class User {
  int id;
  String name;
  String email;
  String role;
  String avatar;
  DateTime last_login;

  Department department;
  Group group;
  Shift shift;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.last_login,
  });

  User.fromJson(Map<String, dynamic> json) {
    id    = json['id'];
    name  = json['name'];
    email = json['email'];
    role  = json['role'];
    avatar  = json['avatar'];
    if (json['last_login'] != '') {
      last_login = DateTime.parse(json['last_login']);
    }

    department  = Department.fromJson(json['department']);
    group       = Group.fromJson(json['group']);
    shift       = Shift.fromJson(json['shift']);
  }

  String get Role {
    if (this.role == 'Employee') {
      return 'Empleado';
    }
    if (this.role == 'Manager') {
      return 'Encargado';
    }
    return 'Administrador';
  }
}