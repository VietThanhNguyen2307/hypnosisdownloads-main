import 'dart:convert';
import 'dart:io';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/app/config.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/library/data/model/session.dart';

class SessionsRepository {
  const SessionsRepository(
    this.httpClient,
    this.currentUserRepository,
  );

  final Dio httpClient;
  final CurrentUserRepository currentUserRepository;

  List<ProductPack> get audioPacks =>
      Hive.box<ProductPack>('audioPacks').values.toList();

  List<ProductPack> get scriptPacks =>
      Hive.box<ProductPack>('scriptPacks').values.toList();

  List<ProductPack> get audioWithScriptPacks => Hive.box<ProductPack>(
        'audioWithScriptPacks',
      ).values.toList();
  List<Product> get audios => Hive.box<Product>('recentAudios').values.toList();
  List<Product> get scripts => Hive.box<Product>('scripts').values.toList();

  Future<void> init(Session session) async {
    await writeAudiosToBox(
      [
        ...session.audios,
        ...[for (final pack in session.audioPacks) ...pack.products],
        ...[
          for (final pack in session.audioWithScriptPacks)
            ...pack.products
                .where((element) => element.type == DownloadProductType.audio)
        ],
      ],
    );

    await writeRecentAudiosToBox(session.audios);
    await writeScriptsToBox(session.scripts);

    await writeAudioPacksToBox(session.audioPacks);
    await writeScriptPacksToBox(session.scriptPacks);
    await writeAudioWithScriptPacksToBox(session.audioWithScriptPacks);
  }

  Future<Session> getOfflineSessionForDownloadedProducts() async {
    final completedTasks = (await FlutterDownloader.loadTasks() ?? [])
        .where((task) =>
            task.status == DownloadTaskStatus.complete &&
            task.filename != null)
        .toList();

    final downloadedFilenames =
        completedTasks.map((task) => task.filename!).toSet();
    final existingDownloadedPaths = completedTasks
        .map((task) => '${task.savedDir}/${task.filename}')
        .where((filePath) => File(filePath).existsSync())
        .toSet();

    bool isDownloaded(Product product) {
      if (downloadedFilenames.contains(product.filename)) {
        return true;
      }
      return existingDownloadedPaths
          .any((path) => path.endsWith(product.filename));
    }

    List<Product> filterProducts(List<Product> products) =>
        products.where(isDownloaded).toList();

    List<ProductPack> filterPacks(List<ProductPack> packs) => packs
        .map((pack) => pack.copyWith(products: filterProducts(pack.products)))
        .where((pack) => pack.products.isNotEmpty)
        .toList();

    final session = Session(
      audioPacks: filterPacks(audioPacks),
      scriptPacks: filterPacks(scriptPacks),
      audioWithScriptPacks: filterPacks(audioWithScriptPacks),
      audios: filterProducts(audios),
      scripts: filterProducts(scripts),
    );

    return session;
  }

  Future<Session> getSession() async {
    final user = currentUserRepository.currentUser;
    final userSessionFormData = FormData.fromMap(
      {
        "action": Config.userSessionAction,
        "rev": 5,
        "name": user.email,
        "pass": user.accessToken,
      },
    );

    final response = await httpClient.post(
      "/${Config.userSessionsPath}",
      data: userSessionFormData,
    );

    final responseErrorCode = jsonDecode(response.data)['error'];
    if (responseErrorCode > 0) {
      throw Exception(jsonDecode(response.data)['errorstr']);
    } else if (responseErrorCode < 0) {
      throw Exception(responseErrorCode);
    }

    final session = jsonDecode(response.data)['history'] as List<dynamic>;

    List<ProductPack> productPacks = [];
    List<Product> products = [];

    for (final sessionResponse in session) {
      final sessionItem = Map<String, dynamic>.from(sessionResponse);

      if (sessionItem.containsKey('type')) {
        if (sessionItem['downloadtype'].toString().isNotEmpty &&
            !sessionItem['downloadtype'].toString().contains('epub')) {
          switch (sessionItem['type']) {
            case 'downloadable':
              final product = Product.fromJson(sessionItem);
              switch (product.type) {
                case DownloadProductType.audio:
                  products.add(product);
                  break;
                case DownloadProductType.script:
                  products.add(product);
                  break;
                case DownloadProductType.audioWithScript:
                  break;
              }
              break;
            case 'bundle':
              final pack = ProductPack.fromJson(sessionItem);
              switch (pack.type) {
                case DownloadProductType.audio:
                  if (pack.hasProductsWithBrokenPlaylist) break;
                  productPacks.add(pack);
                  break;
                case DownloadProductType.script:
                  productPacks.add(pack);
                  break;
                case DownloadProductType.audioWithScript:
                  if (pack.hasProductsWithBrokenPlaylist) break;

                  productPacks.add(pack);
                  break;
              }
              break;
          }
        }
      }
    }

    final audios = products
        .where((element) => element.type == DownloadProductType.audio)
        .toList();

    audios.sort((a, b) => b.orderTime.compareTo(a.orderTime));

    final scripts = products
        .where((element) => element.type == DownloadProductType.script)
        .toList();

    scripts.sort((a, b) => b.orderTime.compareTo(a.orderTime));

    final audioPacks = productPacks
        .where((element) => element.type == DownloadProductType.audio)
        .toList();

    audioPacks.sort((a, b) => b.orderTime.compareTo(a.orderTime));

    final scriptPacks = productPacks
        .where((element) => element.type == DownloadProductType.script)
        .toList();

    scriptPacks.sort((a, b) => b.orderTime.compareTo(a.orderTime));

    final audioWithScriptPacks = productPacks
        .where((element) => element.type == DownloadProductType.audioWithScript)
        .toList();

    audioWithScriptPacks.sort((a, b) => b.orderTime.compareTo(a.orderTime));

    return Session(
      audioPacks: audioPacks.toList(),
      scriptPacks: scriptPacks.toList(),
      audioWithScriptPacks: audioWithScriptPacks.toSet().toList(),
      audios: audios.toList(),
      scripts: scripts.toList(),
    );
  }

  /// Write [audios] to audios box
  Future<void> writeAudiosToBox(List<Product> audios) async {
    await Hive.box<Product>('audios').clear();

    final mappedAudios = <String, Product>{};
    for (final audio in audios) {
      if (mappedAudios[audio.id] != null) {
        if (!mappedAudios[audio.id]!.isFromPlaylist) {
          mappedAudios[audio.id] = audio;
        }
      } else {
        mappedAudios[audio.id] = audio;
      }
    }

    await Hive.box<Product>('audios').putAll(mappedAudios);
  }

  /// Write [scripts] to scripts box
  Future<void> writeScriptsToBox(List<Product> scripts) async {
    await Hive.box<Product>('scripts').clear();
    await Hive.box<Product>('scripts')
        .putAll({for (final script in scripts) script.id: script});
  }

  /// Write [audios] to recentAudios box
  Future<void> writeRecentAudiosToBox(List<Product> audios) async {
    await Hive.box<Product>('recentAudios').clear();
    await Hive.box<Product>('recentAudios')
        .putAll({for (final audio in audios) audio.id: audio});
  }

  /// Write [audioPacks] to audioPacks box
  Future<void> writeAudioPacksToBox(List<ProductPack> audioPacks) async {
    await Hive.box<ProductPack>('audioPacks').clear();
    await Hive.box<ProductPack>('audioPacks')
        .putAll({for (final pack in audioPacks) pack.id: pack});
  }

  /// Write [scriptPacks] to scriptPacks box
  Future<void> writeScriptPacksToBox(List<ProductPack> scriptPacks) async {
    await Hive.box<ProductPack>('scriptPacks').clear();
    await Hive.box<ProductPack>('scriptPacks')
        .putAll({for (final pack in scriptPacks) pack.id: pack});
  }

  /// Write [audioWithScriptPacks] to audioWithScriptPacks box
  Future<void> writeAudioWithScriptPacksToBox(
    List<ProductPack> audioWithScriptPacks,
  ) async {
    await Hive.box<ProductPack>('audioWithScriptPacks').clear();
    await Hive.box<ProductPack>('audioWithScriptPacks')
        .putAll({for (final pack in audioWithScriptPacks) pack.id: pack});
  }
}
