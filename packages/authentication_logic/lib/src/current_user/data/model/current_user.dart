import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'current_user.freezed.dart';
part 'current_user.g.dart';

@freezed
@HiveType(typeId: 6)
class CurrentUser with _$CurrentUser {
  const factory CurrentUser({
    @JsonKey(name: 'password') @HiveField(0) required String accessToken,
    @HiveField(1) required String email,
    @HiveField(2) required String name,
    @JsonKey(name: 'growthzone')
    @HiveField(3)
    @Default(
        false) // Specifying default value is not enouph for some reason, so don't make this field non-nullable
    bool? isGrowthZoneMember,
  }) = _CurrentUser;

  factory CurrentUser.fromJson(Map<String, Object?> json) =>
      _$CurrentUserFromJson(json);

  factory CurrentUser.loggedOut() =>
      const CurrentUser(accessToken: '', email: '', name: '');

  factory CurrentUser.mocked() => const CurrentUser(
        accessToken: 'Mocked access token',
        email: 'email@example.com',
        name: 'Mocked Name',
      );
}
