import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class Product extends Equatable {
  const Product(this.id, this.name, this.link, this.filename, this.orderTime,
      this.type, this.idInPlaylist);

  @JsonKey(name: 'prodid')
  @HiveField(0)
  final String id;
  @JsonKey(name: 'prodname')
  @HiveField(1)
  final String name;
  @JsonKey(name: 'ordertime')
  @HiveField(2)
  final DateTime orderTime;
  @HiveField(3)
  final String link;
  @HiveField(4)
  final String filename;
  @JsonKey(name: 'downloadtype')
  @HiveField(5)
  final DownloadProductType type;
  @JsonKey(name: 'plrefid')
  @HiveField(6)
  final String? idInPlaylist;

  factory Product.mocked(String name) => Product(
      '-',
      name,
      'https://www.hypnosisdownloads.com/$name',
      '',
      DateTime.now(),
      DownloadProductType.audio,
      null);

  /// Connect the generated [_$ProductFromJson] function to the `fromJson`
  /// factory.
  factory Product.fromJson(Map<String, dynamic> json) {
    json['prodname'] = HtmlCharacterEntities.decode(json['prodname']);
    return _$ProductFromJson(json);
  }

  /// Connect the generated [_$ProductToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        filename,
        orderTime,
        type,
        idInPlaylist
      ]; // Do not add "link" to props, because link changes if the product is downloaded.

  Product copyWith({
    String? id,
    String? name,
    String? link,
    String? filename,
    DateTime? orderTime,
    DownloadProductType? type,
    String? playlist,
  }) {
    return Product(
      id ?? this.id,
      name ?? this.name,
      link ?? this.link,
      filename ?? this.filename,
      orderTime ?? this.orderTime,
      type ?? this.type,
      playlist ?? idInPlaylist,
    );
  }

  bool get isFromPlaylist => (idInPlaylist == null)
      ? false
      : RegExp(r'^([0-9]+?:?[\w.-]+)$').hasMatch(idInPlaylist!);
}

extension ProductExtension on Product {
  bool isQuickBreaks() => link.contains("Quick-Break");
  String getAlbumName() =>
      isQuickBreaks() ? "Growth zone: Quick Breaks" : "Uncommon Knowledge";
}
