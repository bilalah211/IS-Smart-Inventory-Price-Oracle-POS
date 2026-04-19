import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/core/services/local_storage.dart';
import 'package:smartinevntary/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartinevntary/features/auth/domain/usecases/login_user.dart';
import 'package:smartinevntary/features/auth/presentation/bloc/bloc_events/auth_events.dart';
import 'package:smartinevntary/features/auth/presentation/bloc/bloc_states/auth_states.dart';
import '../../../domain/usecases/logout_user.dart';
import '../../../domain/usecases/register_user.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final LoginUser loginUsers;
  final RegisterUser registerUsers;
  final LogoutUser logoutUsers;
  final LocalStorageServices localStorageServices;

  AuthBloc(
    this.loginUsers,
    this.registerUsers,
    this.logoutUsers,
    this.localStorageServices,
  ) : super(AuthInitialState()) {
    // LOGIN
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final user = await loginUsers(event.email, event.password);
        await localStorageServices.setData(event.isRemember);
        emit(AuthLoadedState(user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    // REGISTER
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await registerUsers(event.email, event.password);
        emit(AuthLoadedState(user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    // LOGOUT
    on<LogoutEvent>((event, emit) async {
      logoutUsers;
      await localStorageServices.setData(false);
    });
  }
}
