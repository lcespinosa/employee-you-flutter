import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:starterkit/api/api_base_helper.dart';
import 'package:starterkit/blocs/login/login_bloc.dart';
import 'package:starterkit/blocs/login/login_event.dart';
import 'package:starterkit/repositories/auth_repository.dart';

import 'blocs/auth/authentication_bloc.dart';
import 'blocs/auth/authentication_event.dart';
import 'utils/router.dart';
import 'utils/styles.dart';
import 'views/pages/unknown_page.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  final client = Client();
  final apiSrv = ApiBaseHelper(client);
  final authSrv = AuthRepository(apiSrv);


  runApp(MultiProvider(
    providers: [
      Provider<ApiBaseHelper>(create: (_) => apiSrv),
      Provider<AuthRepository>(create: (_) => authSrv),
    ],
    child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              final authService = RepositoryProvider.of<AuthRepository>(context);
              return AuthenticationBloc(authService)..add(AppLoaded());
            }
          ),
          BlocProvider<LoginBloc>(
            create: (context) {
              final authService = RepositoryProvider.of<AuthRepository>(context);
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              return LoginBloc(authBloc, authService)..add(LoginLoaded());
            }
          ),
        ],
        child: MyApp(),
    )
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employees-Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors
        // brightness: Brightness.dark,
        primaryColor: Styles.appPrimaryColor,
        accentColor: Styles.appAccentColor,
        brightness: Brightness.light,

        // for drawer color
        canvasColor: Styles.appCanvasColor,

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: Styles.appTextTheme,
      ),
      initialRoute: '/',
      routes: appRoutes,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => UnknownPage(),
        );
      },
    );
  }
}
