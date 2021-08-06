import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:starterkit/models/user.dart';
import 'package:starterkit/repositories/auth_repository.dart';
import 'package:starterkit/views/auth/login.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  AuthGuard({
    @required
    this.child
  }) {
    assert(this.child != null);
  }

  @override
  _AuthGuardState createState() {
    return new _AuthGuardState();
  }
}

class _AuthGuardState extends State<AuthGuard> {
  Widget currentWidget;

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<User>(
      valueListenable: Provider.of<AuthRepository>(
        context,
        listen: false,
      ),
      builder: (context, user, child) {
        return Navigator(
          pages: [
            MaterialPage(child: LoginPage(), fullscreenDialog: true),
            //
            if (user != null)
              MaterialPage(child: widget.child, fullscreenDialog: true),
          ],
          onPopPage: (route, result) => !route.isFirst,
        );
      },
    );
  }
}