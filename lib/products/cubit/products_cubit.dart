import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/products/data/products_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.productsRepository) : super(const ProductsStateInitial());

  final ProductsRepository productsRepository;

  Future<void> onPageOpened() async {
    await _showProducts();
  }

  Future<void> onLogout() async {
    emit(const ProductsStateInitial());
  }

  Future<List<ProductPack>> getPacks() async {
    final boxPacks = Hive.box<ProductPack>('audioPacks').values;
    final recentAudios = Hive.box<Product>('recentAudios').values;

    final recentAudioPack = ProductPack(
      'recent',
      'Recent audios',
      DateTime.now(),
      recentAudios.toList(),
      DownloadProductType.audio,
    );

    return [recentAudioPack, ...boxPacks];
  }

  Future<void> _showProducts() async {
    emit(const ProductsLoadInProgress());
    try {
      final products = await productsRepository.getProducts();
      emit(ProductsLoadSuccess(products));
    } on UserCanceledException catch (_) {
      emit(const ProductsStateInitial());
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Products load failure',
        fatal: false,
      );
      emit(ProductsLoadFailure(parseErrorMessageFrom(error)));
    }
  }
}
