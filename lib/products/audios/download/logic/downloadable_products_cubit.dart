import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/download/data/product_to_download_task_map.dart';

part 'downloadable_products_state.dart';

class DownloadableProductsCubit extends Cubit<DownloadableProductsState> {
  DownloadableProductsCubit(this.downloadableProductsRepository)
      : super(const DownloadableProductsStateInitial());

  final DownloadableProductsRepository downloadableProductsRepository;
  FilteringMode filter = FilteringMode.none;
  List<Downloadable<Product>>? initialDownloadableProducts;

  Future<void> onAppOpened() async {
    _startListeningToDownloadStatus();
  }

  Future<void> onPageOpened(List<Product> products) async {
    await _showDownloadStatusFor(products);
  }

  Future<void> onPageClosed() async {
    emit(const DownloadableProductsStateInitial());
  }

  Future<void> onLogout() async {
    _stopListeningToDownloadStatus();
    emit(const DownloadableProductsStateInitial());
    initialDownloadableProducts = null;
  }

  Future<void> onActionTap(Downloadable<Product> downloadable) async {
    if (downloadable.status == DownloadTaskStatus.undefined.index) {
      await _requestDownload(downloadable);
    } else if (downloadable.status == DownloadTaskStatus.running.index) {
      await _cancelDownload(downloadable);
    } else if (downloadable.status == DownloadTaskStatus.paused.index) {
      await _resumeDownload(downloadable);
    } else if (downloadable.status == DownloadTaskStatus.complete.index) {
      await delete(downloadable);
    } else if (downloadable.status == DownloadTaskStatus.failed.index) {
      await delete(downloadable);
      await _requestDownload(downloadable);
    } else if (downloadable.status == DownloadTaskStatus.canceled.index) {
      await delete(downloadable);
      await _requestDownload(downloadable);
    }
  }

  Future<void> onBulkActionTap() async {
    final state = this.state;
    if (state is DownloadableProductsLoadSuccess) {
      if (areSomeProductsDownloaded()) {
        for (final downloadable in state.downloadableProducts) {
          if (downloadable.status == DownloadTaskStatus.running.index ||
              downloadable.status == DownloadTaskStatus.enqueued.index) {
            await _cancelDownload(downloadable);
          }
          delete(downloadable);
        }
      } else {
        for (final downloadable in state.downloadableProducts) {
          if (downloadable.status == DownloadTaskStatus.undefined.index) {
            await _requestDownload(downloadable);
          } else if (downloadable.status == DownloadTaskStatus.canceled.index) {
            await delete(downloadable);
            await _requestDownload(downloadable);
          } else if (downloadable.status == DownloadTaskStatus.paused.index) {
            await _resumeDownload(downloadable);
          } else if (downloadable.status == DownloadTaskStatus.failed.index) {
            await delete(downloadable);
            await _requestDownload(downloadable);
          }
        }
      }
    }
  }

  Future<void> onDownloadAllProductsTap() async {
    final state = this.state;
    if (state is DownloadableProductsLoadSuccess) {
      for (final downloadable in state.downloadableProducts) {
        if (downloadable.status == DownloadTaskStatus.undefined.index ||
            downloadable.status == DownloadTaskStatus.canceled.index) {
          _requestDownload(downloadable);
        }
      }
    }
  }

  Future<void> onCancel(Downloadable<Product> downloadable) async {
    await delete(downloadable);
  }

  bool areSomeProductsDownloaded() {
    final currentState = state;
    if (currentState is DownloadableProductsLoadSuccess) {
      return currentState.downloadableProducts.any((downloadable) =>
          downloadable.status != DownloadTaskStatus.undefined.index &&
          downloadable.status != DownloadTaskStatus.canceled.index &&
          downloadable.status != DownloadTaskStatus.failed.index);
    } else {
      return false;
    }
  }

  bool areAllProductsDownloaded() {
    final currentState = state;
    if (currentState is DownloadableProductsLoadSuccess) {
      return currentState.downloadableProducts.every((downloadable) =>
          downloadable.status == DownloadTaskStatus.complete.index);
    } else {
      return false;
    }
  }

  Future<Downloadable<Product>> getDownloadStatusForSingle(
      Product product) async {
    return (await downloadableProductsRepository
            .getDownloadStatusFor([product]))
        .first;
  }

  void _startListeningToDownloadStatus() {
    downloadableProductsRepository
        .startReceivingDownloadStatus()
        .listen((dynamic data) {
      String taskId = data[0];
      int status = data[1];
      int progress = data[2];

      if (state is DownloadableProductsLoadSuccess) {
        final downloadables =
            (state as DownloadableProductsLoadSuccess).downloadableProducts;
        try {
          final downloadable =
              downloadables.firstWhere((d) => d.taskId == taskId);
          _updateStateWith(downloadable.copyWith(
            status: status,
            downloadedPercent: progress,
          ));
        } on StateError catch (_) {
          // Product just started downloading, there is no Downloadable object yet
        }
      }
    });
  }

  void _stopListeningToDownloadStatus() {
    downloadableProductsRepository.stopReceivingDownloadStatus();
  }

  void applyFilter(FilteringMode filter) {
    final currentState = state;
    if (currentState is DownloadableProductsLoadSuccess) {
      this.filter = filter;
      emit(DownloadableProductsLoadSuccess(
          (state as DownloadableProductsLoadSuccess).downloadableProducts));
    }
  }

  Future<void> _showDownloadStatusFor(List<Product> products) async {
    emit(const DownloadableProductsLoadInProgress());
    try {
      final downloadableProducts =
          await downloadableProductsRepository.getDownloadStatusFor(products);
      _retainKnownDownloadTaskIdsFor(downloadableProducts);
      _sortByProductOrderTimeDescending(downloadableProducts);
      initialDownloadableProducts = downloadableProducts;
      emit(DownloadableProductsLoadSuccess(downloadableProducts));
    } on UserCanceledException catch (_) {
      emit(const DownloadableProductsStateInitial());
    } catch (e) {
      emit(DownloadableProductsLoadFailure(parseErrorMessageFrom(e)));
    }
  }

  void _updateStateWith(Downloadable<Product> downloadable) {
    final currentState = state;
    if (currentState is DownloadableProductsLoadSuccess) {
      final newDownloadableProducts = currentState.downloadableProducts
          .map((d) => d.item.id == downloadable.item.id ? downloadable : d)
          .toList();
      initialDownloadableProducts = newDownloadableProducts;
      emit(DownloadableProductsLoadSuccess(newDownloadableProducts));
    }
  }

  Future<void> _requestDownload(Downloadable<Product> downloadable) async {
    final taskId =
        await downloadableProductsRepository.requestDownload(downloadable);
    _updateStateWith(downloadable.copyWith(taskId: taskId));
  }

  Future<void> _cancelDownload(Downloadable<Product> downloadable) async {
    await downloadableProductsRepository.cancelDownload(downloadable);
    _updateStateWith(downloadable.copyWith(taskId: downloadable.taskId));
  }

  Future<void> _resumeDownload(Downloadable<Product> downloadable) async {
    final taskId =
        await downloadableProductsRepository.resumeDownload(downloadable);
    _updateStateWith(downloadable.copyWith(taskId: taskId));
  }

  Future<void> _retryDownload(Downloadable<Product> downloadable) async {
    final taskId =
        await downloadableProductsRepository.retryDownload(downloadable);
    _updateStateWith(downloadable.copyWith(taskId: taskId));
  }

  Future<void> delete(Downloadable<Product> downloadable) async {
    await downloadableProductsRepository.delete(downloadable);
    _updateStateWith(
        downloadable.copyWith(status: DownloadTaskStatus.undefined.index));
  }

  List<Downloadable<Product>> _retainKnownDownloadTaskIdsFor(
      List<Downloadable<Product>> downloadableProducts) {
    productToDownloadTaskMap.forEach((productId, taskId) {
      final downloadable =
          downloadableProducts.firstWhereOrNull((d) => d.item.id == productId);
      if (downloadable != null) {
        final index = downloadableProducts.indexOf(downloadable);
        downloadableProducts.remove(downloadable);
        downloadableProducts.insert(
            index, downloadable.copyWith(taskId: taskId));
      }
    });
    return downloadableProducts;
  }

  void _sortByProductOrderTimeDescending(
      List<Downloadable<Product>> downloadableProducts) {
    downloadableProducts.sort((a, b) {
      final aOrderTime = a.item.orderTime;
      final bOrderTime = b.item.orderTime;
      return bOrderTime.compareTo(aOrderTime);
    });
  }
}
