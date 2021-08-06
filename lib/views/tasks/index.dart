import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterkit/api/api_response.dart';
import 'package:starterkit/blocs/project_bloc.dart';
import 'package:starterkit/blocs/task_bloc.dart';
import 'package:starterkit/models/task.dart';
import 'package:starterkit/views/components/search_list.dart';
import 'package:starterkit/views/partials/api_error.dart';
import 'package:starterkit/views/partials/loading.dart';
import 'package:provider/provider.dart';

class TasksIndexList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TasksIndexListState();
}

class _TasksIndexListState extends State<TasksIndexList> {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<TaskBloc>(context, listen: false);
    print(context);
    return RefreshIndicator(
      onRefresh: () => _bloc.fetchTaskList(),
      child: StreamBuilder<ApiResponse<List<Task>>>(
        stream: _bloc.taskListStream,
        builder: (constext, snapshot) {
          if (snapshot.hasData) {
            switch(snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
              case Status.COMPLETED:
                return taskList(context, snapshot.data.data);
              case Status.ERROR:
                return ApiError(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchTaskList(),
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

}

Widget taskList(context, data) {
  final _projectBloc = BlocProvider.of<ProjectBloc>(context);
  final _taskBloc = BlocProvider.of<TaskBloc>(context);
  return BlocBuilder(
    cubit: _projectBloc,
    builder: (pcontext, ProyectState) {
      return BlocBuilder(
        cubit: _taskBloc,
        builder: (tcontext, TaskState) {
          var selection;
          if (TaskState is TaskSelection) {
            selection = TaskState.taskId;
          }
          else if (ProyectState is ProjectSelection) {
            var projectId = ProyectState.projectId;
            var dataFiltered = [];
            for (int i=0; i<data.length; i++) {
              if (data[i].projectId == projectId) {
                dataFiltered.add(data[i]);
              }
            }
            data = dataFiltered;
          }

          return SearchList('Listado de tareas', data, displayData: 'name',
            selectedId: selection,
            onSelected: (element) {
              _taskBloc.add(TaskSelected(task: element));
            },);
        });
    }
  );
}