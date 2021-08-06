import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterkit/api/api_base_helper.dart';
import 'package:starterkit/blocs/auth/authentication_bloc.dart';
import 'package:starterkit/blocs/auth/authentication_event.dart';
import 'package:provider/provider.dart';
import 'package:starterkit/blocs/project_bloc.dart';
import 'package:starterkit/blocs/task_bloc.dart';
import 'package:starterkit/models/user.dart';
import 'package:starterkit/repositories/auth_repository.dart';
import 'package:starterkit/utils/constants.dart';
import 'package:starterkit/utils/styles.dart';
import 'package:starterkit/views/components/time_counter.dart';
import 'package:starterkit/views/projects/index.dart';
import 'package:starterkit/views/tasks/index.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Panel de trabajo"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder<User>(
        valueListenable: Provider.of<AuthRepository>(
          context,
          listen: false,
        ),
        builder: (context, user, child) {
          return Container(
              padding: EdgeInsets.all(Constants.commonPadding),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //Avatar
                      // Image.asset('assets/images/collaboration.png', width: MediaQuery.of(context).size.width/8),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(user.avatar),
                              fit: BoxFit.fill
                            )
                          )
                        )
                      ),
                      //User info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Bienvenido ' + user.name, style: Styles.h1,),
                          Text(user.Role + ' de ' + user.department?.Name, style: Styles.h2,),
                          Text('Equipo: ' + user.group?.Name + ' del Turno: ' + user.shift?.Name, style: Styles.h2,),
                        ],
                      ),
                      Expanded(child: FittedBox(fit: BoxFit.contain,)),
                      //Logout
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Styles.gradientPrimaryColor,
                                          Styles.gradientLastColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(left: 30, right: 30),
                                    primary: Colors.white,
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    authBloc.add(UserLoggedOut());
                                  },//logout
                                  child: const Text('Salir'),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(5)),
                          //Counter time
                          TimeCounter(),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                      child:WorkContentInfo(),
                  ),
                ],
              ),
            );
          }
      )
    );
  }

}

class WorkContentInfo extends StatefulWidget {

  @override
  _WorkContentInfoState createState() => _WorkContentInfoState();
}

class _WorkContentInfoState extends State<WorkContentInfo> {

  static const List<Color> clockInColors = <Color>[
    Styles.matchWonCardSideColor,
    Styles.commonDarkGradient,
  ];
  static const List<Color> clockOutColors = <Color>[
    Styles.matchLostCardSideColor,
    Styles.commonDarkGradient,
  ];

  @override
  Widget build(BuildContext context) {
    final apiHelper = Provider.of<ApiBaseHelper>(context);

    return MultiBlocProvider(providers: [
      BlocProvider<TaskBloc>(lazy: false, create: (context) {
        return TaskBloc(apiHelper)..add(TaskLoaded());
      }),
      BlocProvider<ProjectBloc>(lazy: false, create: (context) {
        final taskBloc = Provider.of<TaskBloc>(context, listen: false);
        print(apiHelper);
        return ProjectBloc(taskBloc, apiHelper)..add(ProjectLoaded());
      })
    ],
      child: Padding(
          padding: EdgeInsets.all(10),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return GridView.count(
                // Create a grid with 2 columns in portrait mode,
                // or 3 columns in landscape mode.
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                children: <Widget>[
                  ProjectsIndexList(),
                  TasksIndexList(),
                  Padding(
                      padding: EdgeInsets.only(top: 100, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Descripcion de la tarea: ', style: Styles.h1,),
                          Text('---', style: Styles.p,),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border(
                                            top: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                                            left: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                                            right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                                            bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
                                      child: Text(
                                        '00:30:45',
                                        style: Styles.displayCounter,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              // colors: clockInColors,
                                              colors: clockOutColors,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(left: 30, right: 30),
                                          primary: Colors.white,
                                          textStyle: const TextStyle(fontSize: 20),
                                        ),
                                        onPressed: () {
                                        },//logout
                                        child: const Text('Marcar salida'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  )
                ],
              );
            },
          )
      )
    );
  }
}