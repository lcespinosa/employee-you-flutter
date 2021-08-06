import 'package:starterkit/models/task.dart';

class TaskResponse {

  List<Task> results;

  TaskResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      results = [];
      json['data'].forEach((t) {
        results.add(Task.fromJson(t));
      });
    }
  }
}