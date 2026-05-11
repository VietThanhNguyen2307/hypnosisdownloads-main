import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/download/data/product_to_download_task_map.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
class DownloadableProductsRepository {
  Directory? savedDir;
  ReceivePort? port;
  final StreamController<dynamic> listener =
      StreamController<dynamic>.broadcast();

  DownloadableProductsRepository() {
    unawaited(init());
  }

  Future<void> init() async {
    final isPermissionReady = await _checkPermission();

    if (isPermissionReady) {
      savedDir = await _prepareSaveDir();
    }
  }

  Stream<dynamic> startReceivingDownloadStatus() {
    if (port == null) {
      port = ReceivePort();
      final isSuccess = IsolateNameServer.registerPortWithName(
          port!.sendPort, 'downloader_send_port');
      if (isSuccess) {
        FlutterDownloader.registerCallback(downloadCallback);
      } else {
        stopReceivingDownloadStatus();
        return startReceivingDownloadStatus();
      }
      port!.listen((message) {
        listener.add(message);
      });
    }
    return listener.stream;
  }

  void stopReceivingDownloadStatus() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    port?.close();
    port = null;
  }

  Future<List<Downloadable<Product>>> getDownloadStatusFor(
      List<Product> products) async {
    final tasks = await FlutterDownloader.loadTasks() ?? [];

    final downloadableProducts = products
        .map((product) => Downloadable(
              item: product,
              name: product.filename,
              onlineUrl: product.link,
              taskId: _getTaskIdOf(product, tasks),
              status: _getDownloadStatusOf(product, tasks),
              offlineUrl: _getOfflineUrlOf(product, tasks),
            ))
        .toList();
    return downloadableProducts;
  }

  Future<Downloadable<Product>> getDownloadStatusForSingle(
      Product product) async {
    return (await getDownloadStatusFor([product])).first;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    } else if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      // For Android 13 and above, check audio permission.
      if (androidInfo.version.sdkInt >= 33) {
        final audioStatus = await Permission.audio.status;
        if (audioStatus != PermissionStatus.granted) {
          final audioResult = await Permission.audio.request();
          return audioResult == PermissionStatus.granted;
        } else {
          return audioStatus == PermissionStatus.granted;
        }
      } else {
        final storageStatus = await Permission.storage.status;
        if (storageStatus != PermissionStatus.granted) {
          final storageResult = await Permission.storage.request();
          return storageResult == PermissionStatus.granted;
        } else {
          return storageStatus == PermissionStatus.granted;
        }
      }
    } else {
      return false;
    }
  }

  Future<Directory> _prepareSaveDir() async {
    final savedDir = await _getDownloadsDirectory();
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
    return savedDir;
  }

  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final prefs = await SharedPreferences.getInstance();
      final downloadsLocation =
          prefs.getString('downloads_location') ?? 'Internal storage';
      if (downloadsLocation == 'External storage' &&
          await getExternalStorageDirectory() != null) {
        return (await getExternalStorageDirectory())!;
      }
    }

    return await getApplicationDocumentsDirectory();
  }

  Future<String?> requestDownload(Downloadable<Product> downloadable) async {
    return await FlutterDownloader.enqueue(
      url: downloadable.onlineUrl,
      savedDir: savedDir!.absolute.path,
      saveInPublicStorage: Platform.isIOS,
      openFileFromNotification: Platform.isIOS,
    );
  }

  Future<void> pauseDownload(Downloadable<Product> downloadable) async {
    await FlutterDownloader.pause(taskId: downloadable.taskId!);
  }

  Future<void> cancelDownload(Downloadable<Product> downloadable) async {
    await FlutterDownloader.cancel(taskId: downloadable.taskId!);
  }

  Future<String?> resumeDownload(Downloadable<Product> downloadable) async {
    return await FlutterDownloader.resume(taskId: downloadable.taskId!);
  }

  Future<String?> retryDownload(Downloadable<Product> downloadable) async {
    return await FlutterDownloader.retry(taskId: downloadable.taskId!);
  }

  Future<void> delete(Downloadable<Product> downloadable) async {
    final isDownloaded = downloadable.taskId != null;
    if (isDownloaded) {
      await FlutterDownloader.remove(
        taskId: downloadable.taskId!,
        shouldDeleteContent: true,
      );
    }
  }

  DownloadTask? getTaskOf(Product product, List<DownloadTask> tasks) {
    return tasks.firstWhereOrNull(
      (task) => task.filename == product.filename,
    );
  }

  String? _getTaskIdOf(Product product, List<DownloadTask> tasks) {
    final task = getTaskOf(product, tasks);
    final taskId = task?.taskId;
    // Preserve local state across calls to DownloadableProductsCubit.onPageOpened()
    productToDownloadTaskMap[product.id] = taskId;
    return taskId;
  }

  int _getDownloadStatusOf(Product product, List<DownloadTask> tasks) {
    final task = getTaskOf(product, tasks);
    if (task != null) {
      return task.status.index;
    } else {
      return DownloadTaskStatus.undefined.index;
    }
  }

  String? _getOfflineUrlOf(Product product, List<DownloadTask> tasks) {
    final status = _getDownloadStatusOf(product, tasks);
    if (status == DownloadTaskStatus.complete.index) {
      final task = getTaskOf(product, tasks)!;
      final offlineUrl = '${task.savedDir}/${task.filename!}';
      return offlineUrl;
    } else {
      return null;
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort port =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    port.send([id, status, progress]);
  }
}
