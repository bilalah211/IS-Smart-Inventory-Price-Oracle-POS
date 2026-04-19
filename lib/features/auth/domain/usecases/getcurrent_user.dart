import 'package:smartinevntary/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository authRepository;

  GetCurrentUser(this.authRepository);

  Future getCurrentUser() async {
    return authRepository.getCurrentUser();
  }
}
