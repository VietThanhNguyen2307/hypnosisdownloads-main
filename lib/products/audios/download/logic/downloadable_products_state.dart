part of 'downloadable_products_cubit.dart';

abstract class DownloadableProductsState extends Equatable {
  const DownloadableProductsState();

  @override
  List<Object?> get props => [];
}

class DownloadableProductsStateInitial extends DownloadableProductsState {
  const DownloadableProductsStateInitial();
}

class DownloadableProductsLoadInProgress extends DownloadableProductsState {
  const DownloadableProductsLoadInProgress();
}

class DownloadableProductsLoadSuccess extends DownloadableProductsState {
  const DownloadableProductsLoadSuccess(this.downloadableProducts);

  final List<Downloadable<Product>> downloadableProducts;

  @override
  List<Object?> get props => [downloadableProducts, identityHashCode(this)];
}

class DownloadableProductsLoadFailure extends DownloadableProductsState {
  const DownloadableProductsLoadFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
