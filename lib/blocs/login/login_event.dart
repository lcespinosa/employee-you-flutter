import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithPinButtonPressed extends LoginEvent {
  final String pin;

  LoginInWithPinButtonPressed({@required this.pin});

  @override
  List<Object> get props => [pin];
}
// Fired just after the app is launched
class LoginLoaded extends LoginEvent {}