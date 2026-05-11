import 'package:authentication_logic/authentication_logic.dart';

class LogoutRepository {
  const LogoutRepository(
    this.currentUserRepository,
  );

  final CurrentUserRepository currentUserRepository;

  Future<void> logout() async {
    currentUserRepository.deleteCurrentUser();
  }
}
