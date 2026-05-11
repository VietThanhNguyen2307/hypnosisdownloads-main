import 'package:authentication_logic/authentication_logic.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentUserRepository {
  CurrentUserRepository(
    this.currentUserBox,
  );

  final Box<CurrentUser> currentUserBox;

  CurrentUser get currentUser =>
      currentUserBox.get('user', defaultValue: CurrentUser.loggedOut())!;
  Stream<CurrentUser> get currentUserStream => currentUserBox
      .watch(key: 'user')
      .map((event) => event.value ?? CurrentUser.loggedOut());

  void set(CurrentUser user) {
    currentUserBox.put('user', user);
  }

  Future<void> update({String? name}) async {
    if (name != null) {
      final user = currentUser.copyWith(name: name);
      set(user);
    }
  }

  void deleteCurrentUser() {
    currentUserBox.delete('user');
  }
}
