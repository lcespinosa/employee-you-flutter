import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:starterkit/models/user.dart';
import 'package:starterkit/responses/login_response.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends AuthenticationEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent {
  final LoginResponse loginResponse;

  UserLoggedIn({@required this.loginResponse});

  @override
  List<Object> get props => [loginResponse];
}

// Fired when the user has logged out
class UserLoggedOut extends AuthenticationEvent {}
