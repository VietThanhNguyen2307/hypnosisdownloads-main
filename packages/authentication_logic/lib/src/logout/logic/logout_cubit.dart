import 'package:authentication_logic/src/logout/data/logout_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this.logoutRepository) : super(const LogoutStateInitial());

  final LogoutRepository logoutRepository;

  Future<void> logout() async {
    emit(const LogoutInProgress());
    try {
      await logoutRepository.logout();
      emit(const LogoutSuccess());
    } on UserCanceledException catch (_) {
      emit(const LogoutStateInitial());
    } catch (e) {
      emit(LogoutFailure(parseErrorMessageFrom(e)));
    }
  }

  Future<void> onBackPressed() async {
    emit(const LogoutStateInitial());
  }
}
