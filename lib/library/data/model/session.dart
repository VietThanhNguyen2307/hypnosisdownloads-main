import 'package:equatable/equatable.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';

class Session extends Equatable {
  const Session({
    required this.audioPacks,
    required this.scriptPacks,
    required this.audioWithScriptPacks,
    required this.audios,
    required this.scripts,
  });

  final List<ProductPack> audioPacks;
  final List<ProductPack> scriptPacks;
  final List<ProductPack> audioWithScriptPacks;
  final List<Product> audios;
  final List<Product> scripts;

  @override
  List<Object> get props =>
      [audioPacks, scriptPacks, audioWithScriptPacks, audios, scripts];

  factory Session.mocked() => const Session(
        audioPacks: [],
        scriptPacks: [],
        audioWithScriptPacks: [],
        audios: [],
        scripts: [],
      );
}
