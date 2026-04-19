import '../../auth_export.dart';

class AuthRemoteDatasource {
  final FirebaseAuth auth;

  AuthRemoteDatasource(this.auth);

  //---Login User---
  Future<User> loginUser(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided.';
        case 'invalid-email':
          throw 'The email address is badly formatted.';
        case 'user-disabled':
          throw 'This user has been disabled.';
        default:
          throw 'An unknown error occurred.';
      }
    } catch (e) {
      throw 'Connection failed. Please try again.';
    }
  }

  //---Register User---
  Future<User> registerUser(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'The email address is already in use.';
        case 'weak-password':
          throw 'The password provided is too weak.';
        case 'invalid-email':
          throw 'The email address is badly formatted.';
        case 'operation-not-allowed':
          throw 'Email/password accounts are not enabled.';
        default:
          throw e.message ?? 'An unknown error occurred.';
      }
    } catch (e) {
      throw 'Connection failed. Please try again.';
    }
  }

  //---Logout User---
  Future<void> logoutUser() async {
    await auth.signOut();
  }

  //---Get Current User---
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }
}
