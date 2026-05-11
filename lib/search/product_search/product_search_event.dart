part of 'product_search_bloc.dart';

abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

class ProductsFetchFromSource extends ProductSearchEvent {
  const ProductsFetchFromSource(this.products, this.packs);

  final List<Product> products;
  final List<ProductPack> packs;

  @override
  List<Object> get props => [products, packs];
}

class ProductSearchFilterChanged extends ProductSearchEvent {
  const ProductSearchFilterChanged(this.filter);

  final String filter;

  @override
  List<Object> get props => [filter];
}

class ProductSearchFilterClear extends ProductSearchEvent {
  const ProductSearchFilterClear();
}

class ProductSearchLogout extends ProductSearchEvent {
  const ProductSearchLogout();
}
