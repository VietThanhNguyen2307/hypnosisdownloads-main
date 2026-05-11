part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsStateInitial extends ProductsState {
  const ProductsStateInitial();
}

class ProductsLoadInProgress extends ProductsState {
  const ProductsLoadInProgress();
}

class ProductsLoadSuccess extends ProductsState {
  const ProductsLoadSuccess(this.products);

  final List<Product> products;

  @override
  List<Object?> get props => [products];
}

class ProductsLoadFailure extends ProductsState {
  const ProductsLoadFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
