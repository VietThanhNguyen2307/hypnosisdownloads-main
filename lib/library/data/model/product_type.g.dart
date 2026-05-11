// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadProductTypeAdapter extends TypeAdapter<DownloadProductType> {
  @override
  final int typeId = 3;

  @override
  DownloadProductType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadProductType.audio;
      case 1:
        return DownloadProductType.script;
      case 2:
        return DownloadProductType.audioWithScript;
      default:
        return DownloadProductType.audio;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadProductType obj) {
    switch (obj) {
      case DownloadProductType.audio:
        writer.writeByte(0);
        break;
      case DownloadProductType.script:
        writer.writeByte(1);
        break;
      case DownloadProductType.audioWithScript:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadProductTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductTypeAdapter extends TypeAdapter<ProductType> {
  @override
  final int typeId = 4;

  @override
  ProductType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductType.single;
      case 1:
        return ProductType.collection;
      default:
        return ProductType.single;
    }
  }

  @override
  void write(BinaryWriter writer, ProductType obj) {
    switch (obj) {
      case ProductType.single:
        writer.writeByte(0);
        break;
      case ProductType.collection:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
