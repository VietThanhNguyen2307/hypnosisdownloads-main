// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CurrentUser _$CurrentUserFromJson(Map<String, dynamic> json) {
  return _CurrentUser.fromJson(json);
}

/// @nodoc
mixin _$CurrentUser {
  @JsonKey(name: 'password')
  @HiveField(0)
  String get accessToken => throw _privateConstructorUsedError;
  @HiveField(1)
  String get email => throw _privateConstructorUsedError;
  @HiveField(2)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'growthzone')
  @HiveField(3)
  bool? get isGrowthZoneMember => throw _privateConstructorUsedError;

  /// Serializes this CurrentUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentUserCopyWith<CurrentUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentUserCopyWith<$Res> {
  factory $CurrentUserCopyWith(
          CurrentUser value, $Res Function(CurrentUser) then) =
      _$CurrentUserCopyWithImpl<$Res, CurrentUser>;
  @useResult
  $Res call(
      {@JsonKey(name: 'password') @HiveField(0) String accessToken,
      @HiveField(1) String email,
      @HiveField(2) String name,
      @JsonKey(name: 'growthzone') @HiveField(3) bool? isGrowthZoneMember});
}

/// @nodoc
class _$CurrentUserCopyWithImpl<$Res, $Val extends CurrentUser>
    implements $CurrentUserCopyWith<$Res> {
  _$CurrentUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? email = null,
    Object? name = null,
    Object? isGrowthZoneMember = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isGrowthZoneMember: freezed == isGrowthZoneMember
          ? _value.isGrowthZoneMember
          : isGrowthZoneMember // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentUserImplCopyWith<$Res>
    implements $CurrentUserCopyWith<$Res> {
  factory _$$CurrentUserImplCopyWith(
          _$CurrentUserImpl value, $Res Function(_$CurrentUserImpl) then) =
      __$$CurrentUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'password') @HiveField(0) String accessToken,
      @HiveField(1) String email,
      @HiveField(2) String name,
      @JsonKey(name: 'growthzone') @HiveField(3) bool? isGrowthZoneMember});
}

/// @nodoc
class __$$CurrentUserImplCopyWithImpl<$Res>
    extends _$CurrentUserCopyWithImpl<$Res, _$CurrentUserImpl>
    implements _$$CurrentUserImplCopyWith<$Res> {
  __$$CurrentUserImplCopyWithImpl(
      _$CurrentUserImpl _value, $Res Function(_$CurrentUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrentUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? email = null,
    Object? name = null,
    Object? isGrowthZoneMember = freezed,
  }) {
    return _then(_$CurrentUserImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isGrowthZoneMember: freezed == isGrowthZoneMember
          ? _value.isGrowthZoneMember
          : isGrowthZoneMember // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentUserImpl implements _CurrentUser {
  const _$CurrentUserImpl(
      {@JsonKey(name: 'password') @HiveField(0) required this.accessToken,
      @HiveField(1) required this.email,
      @HiveField(2) required this.name,
      @JsonKey(name: 'growthzone')
      @HiveField(3)
      this.isGrowthZoneMember = false});

  factory _$CurrentUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentUserImplFromJson(json);

  @override
  @JsonKey(name: 'password')
  @HiveField(0)
  final String accessToken;
  @override
  @HiveField(1)
  final String email;
  @override
  @HiveField(2)
  final String name;
  @override
  @JsonKey(name: 'growthzone')
  @HiveField(3)
  final bool? isGrowthZoneMember;

  @override
  String toString() {
    return 'CurrentUser(accessToken: $accessToken, email: $email, name: $name, isGrowthZoneMember: $isGrowthZoneMember)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentUserImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isGrowthZoneMember, isGrowthZoneMember) ||
                other.isGrowthZoneMember == isGrowthZoneMember));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, email, name, isGrowthZoneMember);

  /// Create a copy of CurrentUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentUserImplCopyWith<_$CurrentUserImpl> get copyWith =>
      __$$CurrentUserImplCopyWithImpl<_$CurrentUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentUserImplToJson(
      this,
    );
  }
}

abstract class _CurrentUser implements CurrentUser {
  const factory _CurrentUser(
      {@JsonKey(name: 'password')
      @HiveField(0)
      required final String accessToken,
      @HiveField(1) required final String email,
      @HiveField(2) required final String name,
      @JsonKey(name: 'growthzone')
      @HiveField(3)
      final bool? isGrowthZoneMember}) = _$CurrentUserImpl;

  factory _CurrentUser.fromJson(Map<String, dynamic> json) =
      _$CurrentUserImpl.fromJson;

  @override
  @JsonKey(name: 'password')
  @HiveField(0)
  String get accessToken;
  @override
  @HiveField(1)
  String get email;
  @override
  @HiveField(2)
  String get name;
  @override
  @JsonKey(name: 'growthzone')
  @HiveField(3)
  bool? get isGrowthZoneMember;

  /// Create a copy of CurrentUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentUserImplCopyWith<_$CurrentUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
