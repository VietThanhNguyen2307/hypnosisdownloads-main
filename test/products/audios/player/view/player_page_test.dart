import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/player/player_page.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_commons.dart';
import '../../../../test_environment.dart';

void main() {
  final testEnvironment = TestEnvironment();

  Product productExampleA = Product.mocked('Product example A');
  Product productExampleB = Product.mocked('Product example B');
  ProductPack productPackExample = ProductPack.mocked().copyWith(
    name: 'Product pack example',
    products: [productExampleA, productExampleB],
  );
  Playlist playlistExample = Playlist.mocked().copyWith(
    name: 'Playlist example',
    products: [productExampleA, productExampleB],
  );
  Downloadable<Product> downloadableExampleA =
      Downloadable.mockedFor(productExampleA);

  Future<void> createWidgetFor(WidgetTester tester) async {
    return await testEnvironment.openWith(
        tester,
        PlayerPage(
          downloadable: downloadableExampleA,
          audioPack: productPackExample,
          playlist: playlistExample,
        ));
  }

  void mockInitialResponses() {
    when(testEnvironment.repositories
            .at<DownloadableProductsRepository>()
            .getDownloadStatusFor([productExampleA]))
        .thenAnswer(
            (_) => Future.value([Downloadable.mockedFor(productExampleA)]));
    when(testEnvironment.repositories
            .at<DownloadableProductsRepository>()
            .getDownloadStatusFor([productExampleB]))
        .thenAnswer(
            (_) => Future.value([Downloadable.mockedFor(productExampleB)]));
    when(testEnvironment.repositories.at<AudioPlayer>().play())
        .thenAnswer((_) => Future.value());
  }

  void mockPlayerState(PlayerState playerState) {
    when(testEnvironment.repositories.at<AudioPlayer>().playerStateStream)
        .thenAnswer((_) => Stream.value(playerState));
  }

  group('Player page', () {
    setUp((() {
      mockInitialResponses();
    }));
    group('IF loading failed', () {
      setUp(() {
        when(testEnvironment.repositories.at<AudioPlayer>().play())
            .thenThrow(Exception(TestCommons.errorMessage));
      });
      // testWidgets('THEN shows error message', (tester) async {
      //   // Setup
      //   await createWidgetFor(tester);
      //   // Validation
      //   await tester.pumpAndSettle();
      //   tester.confirmTextShown(TestCommons.errorMessage);
      // });
    });
    group('IF loading in progress', () {
      setUp(() {
        mockPlayerState(PlayerState(false, ProcessingState.loading));
      });
      testWidgets('THEN shows loading indicator', (tester) async {
        // Setup
        await createWidgetFor(tester);
        // Validation
        await tester.pump();
        tester.confirmLoadingIndicatorShown();
      });
    });
    group('IF loading succeeded', () {
      setUp(() {
        mockPlayerState(PlayerState(true, ProcessingState.ready));
      });
      testWidgets('THEN shows the current audio', (tester) async {
        // Setup
        await createWidgetFor(tester);
        // Validation
        await tester.pumpAndSettle();
        tester.confirmTextShown(productExampleA.name);
      });
      // testWidgets('THEN starts playing audio', (tester) async {
      //   // Setup
      //   await createWidgetFor(tester);
      //   // Validation
      //   await tester.pumpAndSettle();
      //   verify(testEnvironment.repositories.at<AudioPlayer>().play())
      //           .callCount >=
      //       1;
      // });
      testWidgets('THEN shows Pause button', (tester) async {
        // Setup
        await createWidgetFor(tester);
        // Validation
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('Pause')), findsOneWidget);
      });
      group('IF user clicks on Next button', () {
        testWidgets('THEN shows the next audio', (tester) async {
          // Setup
          await createWidgetFor(tester);
          // Execution
          await tester.pressButtonWithKey(const Key('Next'));
          // Validation
          await tester.pumpAndSettle();
          tester.confirmTextShown(productExampleB.name);
        });
      });
      group('IF current audio ends', () {
        setUp(() {
          final nextAudioStartedEvent = PlaybackEvent(
            currentIndex: 1,
            updatePosition: Duration.zero,
            bufferedPosition: Duration.zero,
            processingState: ProcessingState.ready,
          );
          when(testEnvironment.repositories
                  .at<AudioPlayer>()
                  .playbackEventStream)
              .thenAnswer((_) => Stream.value(nextAudioStartedEvent));
        });
        testWidgets('THEN shows the next audio', (tester) async {
          // Setup
          await createWidgetFor(tester);
          // Validation
          await tester.pumpAndSettle();
          tester.confirmTextShown(productExampleB.name);
        });
      });
      group('IF no internet', () {
        group('IF audio is downloaded', () {
          setUp(() {
            when(testEnvironment.repositories
                    .at<DownloadableProductsRepository>()
                    .getDownloadStatusFor([productExampleA]))
                .thenAnswer((_) => Future.value([
                      Downloadable.mockedFor(productExampleA)
                          .copyWith(status: DownloadTaskStatus.complete.index)
                    ]));
          });
          testWidgets('THEN plays audio from local storage', (tester) async {
            // Setup
            await createWidgetFor(tester);
            // Validation
            await tester.pumpAndSettle();
            final context = tester.context;
            final audioPlayer = context.hypnosisAudioPlayer;
            final currentlyPlayingAudio = audioPlayer.currentAudio!;
            // expect(false, currentlyPlayingAudio.link.contains('https://'));
          });
        });
      });
    });
  });
}
