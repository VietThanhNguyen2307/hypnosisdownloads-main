part of 'product_search_bloc.dart';

enum ProductSearchStatus { initial, loading, success, failure }

class ProductSearchState extends Equatable {
  const ProductSearchState({
    this.status = ProductSearchStatus.initial,
    this.products = const [],
    this.productsSearchResult = const [],
    this.packs = const [],
    this.packsSearchResult = const [],
    this.filter = '',
    this.errorMessage = '',
  });

  final ProductSearchStatus status;
  final List<Product> products;
  final List<ProductPack> packs;
  final List<Product> productsSearchResult;
  final List<ProductPack> packsSearchResult;
  final String filter;
  final String errorMessage;

  ProductSearchState copyWith({
    ProductSearchStatus? status,
    List<Product>? products,
    List<ProductPack>? packs,
    List<Product>? productsSearchResult,
    List<ProductPack>? packsSearchResult,
    String? filter,
    String? errorMessage,
  }) =>
      ProductSearchState(
        status: status ?? this.status,
        products: products ?? this.products,
        packs: packs ?? this.packs,
        productsSearchResult: productsSearchResult ?? this.productsSearchResult,
        packsSearchResult: packsSearchResult ?? this.packsSearchResult,
        filter: filter ?? this.filter,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        products,
        packs,
        productsSearchResult,
        packsSearchResult,
        filter,
        errorMessage
      ];
}
