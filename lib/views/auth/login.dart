import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterkit/blocs/auth/authentication_bloc.dart';
import 'package:starterkit/blocs/auth/authentication_event.dart';
import 'package:starterkit/blocs/auth/authentication_state.dart';
import 'package:starterkit/blocs/login/login_bloc.dart';
import 'package:starterkit/blocs/login/login_event.dart';
import 'package:starterkit/blocs/login/login_state.dart';
import 'package:starterkit/views/components/pin_input.dart';
import 'background.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final authBloc = BlocProvider.of<AuthenticationBloc>(context);
        if (state is AuthenticationNotAuthenticated || state is AuthenticationFailure){
          return authForm(); // show authentication form
        }
        if (state is AuthenticationFailure) {
          // show error message
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(state.message),
                  TextButton(
                    child: Text('Retry'),
                    onPressed: () {
                      authBloc.add(AppLoaded());
                    },
                  )
                ],
              ));
        }
        // show splash screen
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      });
    }
}

void _onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

Widget authForm() {

  final pinController = TextEditingController();

  return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final loginBloc = BlocProvider.of<LoginBloc>(context);
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            ScaffoldMessenger(
                child: SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                )
            );
          });
        }
        return Form(
            child: Stack(
              children: <Widget>[

                // main background
                Background(),

                // main login form
                Column(
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.only(top: MediaQuery
                          .of(context)
                          .size
                          .height / 2.3),
                    ),
                    Center(
                      child: Container(
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 40, bottom: 10),
                              child: Text(
                                "PIN",
                                style: TextStyle(fontSize: 16, color: Color(
                                    0xFF999A9A)),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: <Widget>[
                                PinInput(pinController, 30.0, 0.0),
                                Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 65),
                                              child: Text(
                                                'Introduzca su PIN para comenzar ...',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xFFA0A0A0),
                                                    fontSize: 16),
                                              ),
                                            )),
                                        MaterialButton(
                                          onPressed: () {
                                            if (state is! LoginLoading) {
                                              loginBloc.add(LoginInWithPinButtonPressed(pin: pinController.text));
                                            }
                                          },
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 40,
                                          ),
                                          padding: EdgeInsets.all(16),
                                          shape: CircleBorder(),
                                        ),
                                        Container(
                                          child:
                                          state is LoginLoading ? CircularProgressIndicator() : null,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
        );
      }
    );
}

Widget pinInput(controller, double topRight, double bottomRight) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(mContext).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(bottomRight),
                  topRight: Radius.circular(topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.security),
                  hintText: "12345",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
            ),
          ),
        ),
      ),
    );
  });
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/images/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
