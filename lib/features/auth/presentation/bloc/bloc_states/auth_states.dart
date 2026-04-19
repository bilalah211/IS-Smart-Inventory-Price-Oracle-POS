import '../../../domain/entities/user.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthLoadedState extends AuthStates {
  final User user;

  AuthLoadedState(this.user);
}

class AuthErrorState extends AuthStates {
  String message;

  AuthErrorState(this.message);
}
