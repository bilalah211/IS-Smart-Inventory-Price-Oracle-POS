import 'package:smartinevntary/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository authRepository;

  RegisterUser(this.authRepository);

  Future call(String email, String password) async {
    return authRepository.register(email, password);
  }
}
