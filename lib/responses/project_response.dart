import 'package:starterkit/models/project.dart';

class ProjectResponse {

  List<Project> results;

  ProjectResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      results = [];
      json['data'].forEach((p) {
        results.add(Project.fromJson(p));
      });
    }
  }
}