import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterkit/api/api_response.dart';
import 'package:starterkit/blocs/project_bloc.dart';
import 'package:starterkit/models/project.dart';
import 'package:starterkit/views/components/search_list.dart';
import 'package:starterkit/views/partials/api_error.dart';
import 'package:starterkit/views/partials/loading.dart';

class ProjectsIndexList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProjectsIndexListState();
}

class _ProjectsIndexListState extends State<ProjectsIndexList> {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    print(_bloc);
    return RefreshIndicator(
      onRefresh: () => _bloc.fetchProjectList(),
      child: StreamBuilder<ApiResponse<List<Project>>>(
        stream: _bloc.projectListStream,
        builder: (constext, snapshot) {
          if (snapshot.hasData) {
            switch(snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
              case Status.COMPLETED:
                return projectList(context, snapshot.data.data);
              case Status.ERROR:
                return ApiError(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchProjectList(),
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

Widget projectList(context, data) {
  final _bloc = BlocProvider.of<ProjectBloc>(context);
  return BlocBuilder(
    cubit: _bloc,
    builder: (mcontext, state) {
      var selection;
      if (state is ProjectSelection) {
        selection = state.projectId;
      }

      return SearchList('Listado de proyectos', data, displayData: 'name', selectedId: selection, onSelected: (element) {
        _bloc.add(ProjectSelected(project: element));
      },);
    }
  );

}