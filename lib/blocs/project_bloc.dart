import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:starterkit/api/api_response.dart';
import 'package:starterkit/blocs/task_bloc.dart';
import 'package:starterkit/models/project.dart';
import 'package:starterkit/repositories/project_repository.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectRepository _projectRepository;

  StreamController _projectListController;

  StreamSink<ApiResponse<List<Project>>> get projectListSink => _projectListController.sink;

  Stream<ApiResponse<List<Project>>> get projectListStream => _projectListController.stream;

  TaskBloc _taskBloc;

  ProjectBloc(this._taskBloc, apiHelper) : super(ProjectInitial()) {
    _projectListController = StreamController<ApiResponse<List<Project>>>();
    _projectRepository = ProjectRepository(apiHelper);
    fetchProjectList();
  }

  fetchProjectList() async {
    projectListSink.add(ApiResponse.loading('Fetching projects'));
    try {
      List<Project> projects = await _projectRepository.fetchUserProjects();
      projectListSink.add(ApiResponse.completed(projects));
    } catch (e) {
      projectListSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _projectListController?.close();
  }

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is ProjectLoaded) {
      yield ProjectInitial();
    }

    if (event is ProjectSelected) {
      yield* _mapProjectSelectedToState(event);
    }
  }

  Stream<ProjectState> _mapProjectSelectedToState(ProjectSelected event) async* {
    yield ProjectSelection(projectId: event.project.id);
  }
}

abstract class ProjectEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class ProjectLoaded extends ProjectEvent {}
class ProjectSelected extends ProjectEvent {
  final Project project;

  ProjectSelected({@required this.project});

  @override
  List<Object> get props => [project];
}

abstract class ProjectState extends Equatable {
  @override
  List<Object> get props => [];
}
class ProjectInitial extends ProjectState {}
class ProjectSelection extends ProjectState {
  final int projectId;

  ProjectSelection({@required this.projectId});

  @override
  List<Object> get props => [projectId];
}