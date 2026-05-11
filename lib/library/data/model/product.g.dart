// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 5;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      fields[0] as String,
      fields[1] as String,
      fields[3] as String,
      fields[4] as String,
      fields[2] as DateTime,
      fields[5] as DownloadProductType,
      fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.orderTime)
      ..writeByte(3)
      ..write(obj.link)
      ..writeByte(4)
      ..write(obj.filename)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.idInPlaylist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['prodid'] as String,
      json['prodname'] as String,
      json['link'] as String,
      json['filename'] as String,
      DateTime.parse(json['ordertime'] as String),
      $enumDecode(_$DownloadProductTypeEnumMap, json['downloadtype']),
      json['plrefid'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'prodid': instance.id,
      'prodname': instance.name,
      'ordertime': instance.orderTime.toIso8601String(),
      'link': instance.link,
      'filename': instance.filename,
      'downloadtype': _$DownloadProductTypeEnumMap[instance.type]!,
      'plrefid': instance.idInPlaylist,
    };

const _$DownloadProductTypeEnumMap = {
  DownloadProductType.audio: 'mp3',
  DownloadProductType.script: 'pdf',
  DownloadProductType.audioWithScript: 'mp3+pdf',
};
