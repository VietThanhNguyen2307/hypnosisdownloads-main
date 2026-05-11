import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';

part 'downloadable.freezed.dart';

@freezed
abstract class Downloadable<T> with _$Downloadable<T> {
  const factory Downloadable({
    required T item,
    required String name,
    required String onlineUrl,
    String? taskId,
    @Default(0) int status,
    String? offlineUrl,
    @Default(0) int downloadedPercent,
  }) = _Downloadable<T>;

  factory Downloadable.mockedFor(T product) {
    return Downloadable(
      item: product,
      name: (product as Product).name,
      onlineUrl: product.link,
      offlineUrl: 'assets://${product.name}',
      status: DownloadTaskStatus.undefined.index,
    );
  }
}
