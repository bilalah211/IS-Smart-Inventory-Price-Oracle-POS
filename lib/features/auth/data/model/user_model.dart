import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email});

  factory UserModel.fromFirebase(user) {
    return UserModel(id: user.uid, email: user.email);
  }
}
