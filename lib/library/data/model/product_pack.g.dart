// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_pack.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductPackAdapter extends TypeAdapter<ProductPack> {
  @override
  final int typeId = 1;

  @override
  ProductPack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductPack(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
      (fields[3] as List).cast<Product>(),
      fields[4] as DownloadProductType,
    );
  }

  @override
  void write(BinaryWriter writer, ProductPack obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.orderTime)
      ..writeByte(3)
      ..write(obj.products)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPack _$ProductPackFromJson(Map<String, dynamic> json) => ProductPack(
      json['prodid'] as String,
      json['prodname'] as String,
      DateTime.parse(json['ordertime'] as String),
      (json['subproducts'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      $enumDecode(_$DownloadProductTypeEnumMap, json['downloadtype']),
    );

Map<String, dynamic> _$ProductPackToJson(ProductPack instance) =>
    <String, dynamic>{
      'prodid': instance.id,
      'prodname': instance.name,
      'ordertime': instance.orderTime.toIso8601String(),
      'subproducts': instance.products,
      'downloadtype': _$DownloadProductTypeEnumMap[instance.type]!,
    };

const _$DownloadProductTypeEnumMap = {
  DownloadProductType.audio: 'mp3',
  DownloadProductType.script: 'pdf',
  DownloadProductType.audioWithScript: 'mp3+pdf',
};
