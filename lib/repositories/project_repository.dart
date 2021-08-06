import 'dart:convert';

import 'package:starterkit/api/api_base_helper.dart';
import 'package:starterkit/models/project.dart';
import 'package:starterkit/responses/project_response.dart';
import 'package:starterkit/utils/constants.dart';

class ProjectRepository {

  ApiBaseHelper _helper;

  ProjectRepository(this._helper);

  Future<List<Project>> fetchUserProjects() async {
    final response = await _helper.get(
      Constants.apiBaseUrl + '/operation/user/projects',
    );
    final responseJson = json.decode(response.body.toString());
    return ProjectResponse.fromJson(responseJson).results;
  }
}