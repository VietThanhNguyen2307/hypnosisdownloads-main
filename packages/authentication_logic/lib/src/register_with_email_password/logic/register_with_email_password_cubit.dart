import 'package:authentication_logic/authentication_logic.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_with_email_password_state.dart';

class RegisterWithEmailPasswordCubit extends Cubit<AuthRegisterState> {
  RegisterWithEmailPasswordCubit(
    this._registerWithEmailPasswordRepository,
    this._currentUserRepository,
  ) : super(const AuthRegisterStateInitial());

  final RegisterWithEmailPasswordRepository
      _registerWithEmailPasswordRepository;
  final CurrentUserRepository _currentUserRepository;

  bool isEmailValid(String email) {
    return RegExp(r'^([a-zA-Z0-9_\.-]+)@([\da-zA-Z\.-]+)\.([a-zA-Z\.]{2,6})$')
        .hasMatch(email);
  }

  Future<void> registerWithEmailPassword(
    String email,
    String password,
    String confirmPassword,
    String firstName,
    String lastName,
  ) async {
    emit(const AuthRegisterInProgress());
    if (firstName.isEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      emit(const AuthRegisterFailure('First name missing'));
      return;
    }
    if (lastName.isEmpty &&
        firstName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      emit(const AuthRegisterFailure('Last name missing'));
      return;
    }
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      emit(const AuthRegisterFailure('Please fill in all fields'));
      return;
    }
    if (password != confirmPassword) {
      emit(const AuthRegisterFailure('Passwords do not match'));
      return;
    }
    try {
      final currentUser =
          await _registerWithEmailPasswordRepository.registerWithEmailPassword(
        email,
        password,
        firstName,
        lastName,
      );
      _currentUserRepository.set(currentUser);
      await _currentUserRepository.update(name: '$firstName $lastName');
      emit(const AuthRegisterSuccess());
    } on UserCanceledException catch (_) {
      emit(const AuthRegisterStateInitial());
    } catch (e) {
      emit(AuthRegisterFailure(parseErrorMessageFrom(e)));
    }
  }

  Future<void> onPageOpened() async {
    emit(const AuthRegisterStateInitial());
  }

  Future<void> onBackPressed() async {
    emit(const AuthRegisterStateInitial());
  }
}
