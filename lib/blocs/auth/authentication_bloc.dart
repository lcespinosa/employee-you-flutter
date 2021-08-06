import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:starterkit/repositories/auth_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc(AuthRepository authRepository)
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();
    try {
      final currentUser = await _authRepository.getCurrentUser();

      if (currentUser != null) {
        yield AuthenticationAuthenticated(user: currentUser);
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    yield AuthenticationAuthenticated(user: event.loginResponse.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await _authRepository.signOut();
    yield AuthenticationNotAuthenticated();
  }
}