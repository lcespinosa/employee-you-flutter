import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:starterkit/api/api_response.dart';
import 'package:starterkit/models/task.dart';
import 'package:starterkit/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskRepository _taskRepository;

  StreamController _taskListController;

  StreamSink<ApiResponse<List<Task>>> get taskListSink => _taskListController.sink;

  Stream<ApiResponse<List<Task>>> get taskListStream => _taskListController.stream;

  TaskBloc(apiHelper) : super(TaskInitial()) {
    _taskListController = StreamController<ApiResponse<List<Task>>>();
    _taskRepository = TaskRepository(apiHelper);
    fetchTaskList();
  }

  fetchTaskList() async {
    taskListSink.add(ApiResponse.loading('Fetching tasks'));
    try {
      List<Task> tasks = await _taskRepository.fetchUserTasks();
      taskListSink.add(ApiResponse.completed(tasks));
    } catch (e) {
      taskListSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _taskListController?.close();
  }

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is TaskLoaded) {
      yield TaskInitial();
    }

    if (event is TaskSelected) {
      yield* _mapTaskSelectedToState(event);
    }
  }

  Stream<TaskState> _mapTaskSelectedToState(TaskSelected event) async* {
    yield TaskSelection(taskId: event.task.id);
  }
}

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class TaskLoaded extends TaskEvent {}
class TaskSelected extends TaskEvent {
  final Task task;

  TaskSelected({@required this.task});

  @override
  List<Object> get props => [task];
}

abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}
class TaskInitial extends TaskState {}
class TaskSelection extends TaskState {
  final int taskId;

  TaskSelection({@required this.taskId});

  @override
  List<Object> get props => [taskId];
}