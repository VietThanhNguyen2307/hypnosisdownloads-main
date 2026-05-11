import 'package:authentication_logic/authentication_logic.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithEmailPasswordCubit extends Cubit<AuthState> {
  LoginWithEmailPasswordCubit(
    this._loginWithEmailPasswordRepository,
    this._currentUserRepository,
  ) : super(const AuthStateInitial());

  final LoginWithEmailPasswordRepository _loginWithEmailPasswordRepository;
  final CurrentUserRepository _currentUserRepository;

  Future<void> loginWithEmailPassword(
      String email, String password, bool remember) async {
    emit(const AuthInProgress());
    try {
      final currentUser =
          await _loginWithEmailPasswordRepository.loginWithEmailPassword(
        email,
        password,
        remember,
      );
      _currentUserRepository.set(currentUser);
      emit(const LoginSuccess());
    } on UserCanceledException catch (_) {
      emit(const AuthStateInitial());
    } catch (e) {
      emit(AuthFailure(parseErrorMessageFrom(e)));
    }
  }

  Future<void> onBackPressed() async {
    emit(const AuthStateInitial());
  }
}
