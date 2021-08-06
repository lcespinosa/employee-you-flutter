import 'package:bloc/bloc.dart';
import 'package:starterkit/blocs/auth/authentication_bloc.dart';
import 'package:starterkit/blocs/auth/authentication_event.dart';
import 'package:starterkit/repositories/auth_repository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthRepository _authRepository;

  LoginBloc(AuthenticationBloc authenticationBloc, AuthRepository authRepository)
      : assert(authenticationBloc != null),
        assert(authRepository != null),
        _authenticationBloc = authenticationBloc,
        _authRepository = authRepository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithPinButtonPressed) {
      yield* _mapLoginWithPinToState(event);
    }
    if (event is LoginLoaded) {
      yield* _mapLoginLoadedToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithPinToState(LoginInWithPinButtonPressed event) async* {
    yield LoginLoading();
    try {
      final login = await _authRepository.signInWithPin(event.pin);
      if (login != null) {
        _authenticationBloc.add(UserLoggedIn(loginResponse: login));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }

  Stream<LoginState> _mapLoginLoadedToState(LoginLoaded event) async* {
    yield LoginInitial();
  }
}