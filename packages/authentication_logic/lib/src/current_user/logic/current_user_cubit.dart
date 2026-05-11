import 'package:authentication_logic/src/current_user/data/current_user_repository.dart';
import 'package:authentication_logic/src/current_user/data/model/current_user.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit(this.currentUserRepository)
      : super(const CurrentUserStateInitial());

  final CurrentUserRepository currentUserRepository;

  CurrentUser get currentUser => currentUserRepository.currentUser;

  Future<void> onPageOpened() async {
    await _showCurrentUser();
  }

  Future<void> onBackPressed() async {
    emit(const CurrentUserStateInitial());
  }

  Future<void> _showCurrentUser() async {
    emit(const CurrentUserLoadInProgress());
    try {
      final user = currentUserRepository.currentUser;
      if (user != CurrentUser.loggedOut()) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
      currentUserRepository.currentUserStream.listen((user) {
        if (user != CurrentUser.loggedOut()) {
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      });
    } on UserCanceledException catch (_) {
      emit(const CurrentUserStateInitial());
    } catch (e) {
      emit(CurrentUserLoadFailure(parseErrorMessageFrom(e)));
    }
  }
}
