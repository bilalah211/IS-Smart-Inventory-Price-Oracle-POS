import 'package:smartinevntary/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smartinevntary/features/auth/data/model/user_model.dart';
import 'package:smartinevntary/features/auth/domain/entities/user.dart';
import 'package:smartinevntary/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User?> getCurrentUser() async {
    final user = await remote.getCurrentUser();
    if (user == null) return null;
    return UserModel.fromFirebase(user);
  }

  @override
  Future<void> logOut() async {
    await remote.logoutUser();
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await remote.loginUser(email, password);

    return UserModel.fromFirebase(user);
  }

  @override
  Future<User> register(String email, String password) async {
    final user = await remote.registerUser(email, password);
    return UserModel.fromFirebase(user);
  }
}
