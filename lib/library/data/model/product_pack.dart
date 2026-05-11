import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'product_pack.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class ProductPack extends Equatable {
  const ProductPack(
      this.id, this.name, this.orderTime, this.products, this.type);

  @JsonKey(name: 'prodid')
  @HiveField(0)
  final String id;
  @JsonKey(name: 'prodname')
  @HiveField(1)
  final String name;
  @JsonKey(name: 'ordertime')
  @HiveField(2)
  final DateTime orderTime;
  @JsonKey(name: 'subproducts')
  @HiveField(3)
  final List<Product> products;
  @JsonKey(name: 'downloadtype')
  @HiveField(4)
  final DownloadProductType type;

  /// Connect the generated [_$ProductPackFromJson] function to the `fromJson`
  /// factory.
  factory ProductPack.fromJson(Map<String, dynamic> json) {
    for (Map<String, dynamic> product in json['subproducts']) {
      if (!product.containsKey('prodid')) {
        product['prodid'] = const Uuid().v1();
      }

      if (!product.containsKey('prodname')) {
        product['prodname'] = product['name'];
      }

      if (!product.containsKey('ordertime')) {
        product['ordertime'] = json['ordertime'];
      }

      json['prodname'] = HtmlCharacterEntities.decode(json['prodname']);
    }
    return _$ProductPackFromJson(json);
  }

  ProductPack copyWith({
    String? id,
    String? name,
    DateTime? orderTime,
    List<Product>? products,
    DownloadProductType? type,
  }) {
    return ProductPack(
      id ?? this.id,
      name ?? this.name,
      orderTime ?? this.orderTime,
      products ?? this.products,
      type ?? this.type,
    );
  }

  /// Connect the generated [_$ProductPackToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProductPackToJson(this);

  @override
  List<Object> get props => [id, products, type];

  factory ProductPack.mocked() => ProductPack(
        const Uuid().v1(),
        '',
        DateTime.now(),
        const [],
        DownloadProductType.audio,
      );

  bool get hasProductsWithBrokenPlaylist => products
      .where(
        (element) =>
            element.type == DownloadProductType.audio &&
            !hasRightPlayerId(element.idInPlaylist!),
      )
      .isNotEmpty;

  bool hasRightPlayerId(String? id) {
    if (id == null) return false;

    return RegExp(r'^([0-9]+?:?[\w.-]+)$').hasMatch(id);
  }
}
