import 'package:smartinevntary/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository authRepository;

  LogoutUser(this.authRepository);

  Future call() async {
    return authRepository.logOut();
  }
}
