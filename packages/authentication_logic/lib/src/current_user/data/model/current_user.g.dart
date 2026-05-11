// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentUserAdapter extends TypeAdapter<CurrentUser> {
  @override
  final int typeId = 6;

  @override
  CurrentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUser(
      accessToken: fields[0] as String,
      email: fields[1] as String,
      name: fields[2] as String,
      isGrowthZoneMember: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isGrowthZoneMember);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrentUserImpl _$$CurrentUserImplFromJson(Map<String, dynamic> json) =>
    _$CurrentUserImpl(
      accessToken: json['password'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isGrowthZoneMember: json['growthzone'] as bool? ?? false,
    );

Map<String, dynamic> _$$CurrentUserImplToJson(_$CurrentUserImpl instance) =>
    <String, dynamic>{
      'password': instance.accessToken,
      'email': instance.email,
      'name': instance.name,
      'growthzone': instance.isGrowthZoneMember,
    };
