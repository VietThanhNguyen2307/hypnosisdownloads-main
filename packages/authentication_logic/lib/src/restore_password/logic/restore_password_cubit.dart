import 'package:authentication_logic/src/restore_password/data/restore_password_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'restore_password_state.dart';

class RestorePasswordCubit extends Cubit<RestorePasswordState> {
  RestorePasswordCubit(this.restorePasswordRepository)
      : super(const RequestVerificationStateInitial());

  final RestorePasswordRepository restorePasswordRepository;

  Future<void> restorePasswordVia(String email) async {
    emit(const RequestVerificationInProgress());
    try {
      await restorePasswordRepository.restorePasswordVia(email);
      emit(const RequestVerificationSuccess());
    } on UserCanceledException catch (_) {
      emit(const RequestVerificationStateInitial());
    } catch (e) {
      emit(RequestVerificationFailure(parseErrorMessageFrom(e)));
    }
  }

  Future<void> onBackPressed() async {
    emit(const RequestVerificationStateInitial());
  }
}
