import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';

class ProductsRepository {
  const ProductsRepository(this.httpClient);

  final Dio httpClient;

  Future<List<Product>> getProducts() async {
    return [];
  }

  /// Returns a [Product] from the [Box] with the given playlist [playlist] id.
  Product? getProductById(String playlist) {
    return Hive.box<Product>('audios')
        .values
        .firstWhereOrNull((element) => element.idInPlaylist == playlist);
  }
}
