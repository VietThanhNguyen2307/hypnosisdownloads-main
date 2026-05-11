// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloadable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Downloadable<T> {
  T get item => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get onlineUrl => throw _privateConstructorUsedError;
  String? get taskId => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  String? get offlineUrl => throw _privateConstructorUsedError;
  int get downloadedPercent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DownloadableCopyWith<T, Downloadable<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadableCopyWith<T, $Res> {
  factory $DownloadableCopyWith(
          Downloadable<T> value, $Res Function(Downloadable<T>) then) =
      _$DownloadableCopyWithImpl<T, $Res, Downloadable<T>>;
  @useResult
  $Res call(
      {T item,
      String name,
      String onlineUrl,
      String? taskId,
      int status,
      String? offlineUrl,
      int downloadedPercent});
}

/// @nodoc
class _$DownloadableCopyWithImpl<T, $Res, $Val extends Downloadable<T>>
    implements $DownloadableCopyWith<T, $Res> {
  _$DownloadableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = freezed,
    Object? name = null,
    Object? onlineUrl = null,
    Object? taskId = freezed,
    Object? status = null,
    Object? offlineUrl = freezed,
    Object? downloadedPercent = null,
  }) {
    return _then(_value.copyWith(
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as T,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      onlineUrl: null == onlineUrl
          ? _value.onlineUrl
          : onlineUrl // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      offlineUrl: freezed == offlineUrl
          ? _value.offlineUrl
          : offlineUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadedPercent: null == downloadedPercent
          ? _value.downloadedPercent
          : downloadedPercent // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadableImplCopyWith<T, $Res>
    implements $DownloadableCopyWith<T, $Res> {
  factory _$$DownloadableImplCopyWith(_$DownloadableImpl<T> value,
          $Res Function(_$DownloadableImpl<T>) then) =
      __$$DownloadableImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {T item,
      String name,
      String onlineUrl,
      String? taskId,
      int status,
      String? offlineUrl,
      int downloadedPercent});
}

/// @nodoc
class __$$DownloadableImplCopyWithImpl<T, $Res>
    extends _$DownloadableCopyWithImpl<T, $Res, _$DownloadableImpl<T>>
    implements _$$DownloadableImplCopyWith<T, $Res> {
  __$$DownloadableImplCopyWithImpl(
      _$DownloadableImpl<T> _value, $Res Function(_$DownloadableImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = freezed,
    Object? name = null,
    Object? onlineUrl = null,
    Object? taskId = freezed,
    Object? status = null,
    Object? offlineUrl = freezed,
    Object? downloadedPercent = null,
  }) {
    return _then(_$DownloadableImpl<T>(
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as T,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      onlineUrl: null == onlineUrl
          ? _value.onlineUrl
          : onlineUrl // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      offlineUrl: freezed == offlineUrl
          ? _value.offlineUrl
          : offlineUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadedPercent: null == downloadedPercent
          ? _value.downloadedPercent
          : downloadedPercent // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DownloadableImpl<T> implements _Downloadable<T> {
  const _$DownloadableImpl(
      {required this.item,
      required this.name,
      required this.onlineUrl,
      this.taskId,
      this.status = 0,
      this.offlineUrl,
      this.downloadedPercent = 0});

  @override
  final T item;
  @override
  final String name;
  @override
  final String onlineUrl;
  @override
  final String? taskId;
  @override
  @JsonKey()
  final int status;
  @override
  final String? offlineUrl;
  @override
  @JsonKey()
  final int downloadedPercent;

  @override
  String toString() {
    return 'Downloadable<$T>(item: $item, name: $name, onlineUrl: $onlineUrl, taskId: $taskId, status: $status, offlineUrl: $offlineUrl, downloadedPercent: $downloadedPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadableImpl<T> &&
            const DeepCollectionEquality().equals(other.item, item) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.onlineUrl, onlineUrl) ||
                other.onlineUrl == onlineUrl) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.offlineUrl, offlineUrl) ||
                other.offlineUrl == offlineUrl) &&
            (identical(other.downloadedPercent, downloadedPercent) ||
                other.downloadedPercent == downloadedPercent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(item),
      name,
      onlineUrl,
      taskId,
      status,
      offlineUrl,
      downloadedPercent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadableImplCopyWith<T, _$DownloadableImpl<T>> get copyWith =>
      __$$DownloadableImplCopyWithImpl<T, _$DownloadableImpl<T>>(
          this, _$identity);
}

abstract class _Downloadable<T> implements Downloadable<T> {
  const factory _Downloadable(
      {required final T item,
      required final String name,
      required final String onlineUrl,
      final String? taskId,
      final int status,
      final String? offlineUrl,
      final int downloadedPercent}) = _$DownloadableImpl<T>;

  @override
  T get item;
  @override
  String get name;
  @override
  String get onlineUrl;
  @override
  String? get taskId;
  @override
  int get status;
  @override
  String? get offlineUrl;
  @override
  int get downloadedPercent;
  @override
  @JsonKey(ignore: true)
  _$$DownloadableImplCopyWith<T, _$DownloadableImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
