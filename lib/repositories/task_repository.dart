import 'dart:convert';

import 'package:starterkit/api/api_base_helper.dart';
import 'package:starterkit/models/project.dart';
import 'package:starterkit/models/task.dart';
import 'package:starterkit/responses/project_response.dart';
import 'package:starterkit/responses/task_response.dart';
import 'package:starterkit/utils/constants.dart';

class TaskRepository {

  ApiBaseHelper _helper;

  TaskRepository(this._helper);

  Future<List<Task>> fetchUserTasks() async {
    final response = await _helper.get(
      Constants.apiBaseUrl + '/operation/user/tasks',
    );
    final responseJson = json.decode(response.body.toString());
    return TaskResponse.fromJson(responseJson).results;
  }
}