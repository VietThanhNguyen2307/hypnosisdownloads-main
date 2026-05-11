import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_type.g.dart';

@HiveType(typeId: 3)
enum DownloadProductType {
  @JsonValue("mp3")
  @HiveField(0)
  audio,
  @JsonValue("pdf")
  @HiveField(1)
  script,
  @JsonValue("mp3+pdf")
  @HiveField(2)
  audioWithScript,
}

@HiveType(typeId: 4)
enum ProductType {
  @JsonValue("downloadable")
  @HiveField(0)
  single,
  @JsonValue("bundle")
  @HiveField(1)
  collection,
}
