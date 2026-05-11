import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';

part 'product_search_event.dart';
part 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  ProductSearchBloc() : super(const ProductSearchState()) {
    on<ProductsFetchFromSource>(_onProductsFetchFromSource);
    on<ProductSearchFilterChanged>(_onProductSearchFilterChanged);
    on<ProductSearchFilterClear>(_onProductSearchFilterClear);
    on<ProductSearchLogout>(onLogout);
  }

  Future<void> _onProductsFetchFromSource(
    ProductsFetchFromSource event,
    Emitter<ProductSearchState> emit,
  ) async {
    emit(state.copyWith(products: event.products, packs: event.packs));
  }

  Future<void> _onProductSearchFilterChanged(
    ProductSearchFilterChanged event,
    Emitter<ProductSearchState> emit,
  ) async {
    emit(
      state.copyWith(status: ProductSearchStatus.loading, filter: event.filter),
    );

    if (state.filter.isNotEmpty) {
      final productsSearchResult = state.products
          .where(
            (product) =>
                product.name.toLowerCase().contains(state.filter.toLowerCase()),
          )
          .toSet()
          .toList();
      print('tagx - Looking for ${state.filter}');
      print('tagx - Searching in ${state.products.length} products');
      print('tagx - Searching in ${state.packs.length} packs');
      // Search for products in packs as well
      for (final pack in state.packs) {
        for (final product in pack.products) {
          if (product.name.toLowerCase().contains(state.filter.toLowerCase())) {
            productsSearchResult.add(product);
          }
        }
      }

      final packsSearchResult = state.packs
          .where(
            (pack) =>
                pack.name.toLowerCase().contains(state.filter.toLowerCase()),
          )
          .toSet()
          .toList();
      print('tagx - Found ${productsSearchResult.length} products');
      print('tagx - Found ${packsSearchResult.length} packs');

      emit(
        state.copyWith(
          status: ProductSearchStatus.success,
          productsSearchResult: productsSearchResult,
          packsSearchResult: packsSearchResult,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ProductSearchStatus.initial,
          packsSearchResult: [],
          productsSearchResult: [],
        ),
      );
    }
  }

  Future<void> _onProductSearchFilterClear(
    ProductSearchFilterClear event,
    Emitter<ProductSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductSearchStatus.initial,
        productsSearchResult: [],
        packsSearchResult: [],
        filter: '',
      ),
    );
  }

  Future<void> fetchFromSource({
    required List<Product> products,
    required List<ProductPack> packs,
  }) async {
    add(ProductsFetchFromSource(products, packs));
  }

  Future<void> changeFilter(String filter) async {
    add(ProductSearchFilterChanged(filter));
  }

  Future<void> clear() async {
    add(const ProductSearchFilterClear());
  }

  Future<void> onLogout(
    ProductSearchLogout event,
    Emitter<ProductSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductSearchStatus.initial,
        packs: [],
        products: [],
        productsSearchResult: [],
        packsSearchResult: [],
        filter: '',
        errorMessage: '',
      ),
    );
  }
}
