import 'dart:isolate';

import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/scripts/document_viewer/document_viewer_page.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/library/data/model/session.dart';
import 'package:hypnosis_downloads/library/data/sessions_repository.dart';
import 'package:hypnosis_downloads/library/library_page.dart';
import 'package:mockito/mockito.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../test_commons.dart';
import '../test_environment.dart';

void main() {
  final testEnvironment = TestEnvironment();

  final Product audio =
      Product.mocked('Example audio').copyWith(type: DownloadProductType.audio);
  final Product script = Product.mocked('Example script')
      .copyWith(type: DownloadProductType.script);

  Future<void> createWidgetFor(WidgetTester tester) async {
    return await testEnvironment.openWith(tester, const LibraryPage());
  }

  Downloadable<Product> downloadableFor(Product product, {int status = 0}) {
    return Downloadable(
      item: product,
      name: product.name,
      onlineUrl: 'https://example.com/product',
      status: status,
    );
  }

  void mockInitialResponses(Product product, int status) {
    final downloadable = [
      downloadableFor(product)
          .copyWith(status: DownloadTaskStatus.undefined.index),
      downloadableFor(product)
          .copyWith(status: DownloadTaskStatus.running.index),
      downloadableFor(product)
          .copyWith(status: DownloadTaskStatus.complete.index),
    ].firstWhere((element) => element.status == status);
    final recentAudiosPack = ProductPack(
      'generated',
      'Recent Audios',
      DateTime.now(),
      [downloadable.item],
      DownloadProductType.audio,
    );
    final recentScriptsPack = ProductPack(
      'generated',
      'Recent Scripts',
      DateTime.now(),
      [downloadable.item],
      DownloadProductType.script,
    );
    ProductPack currentPack;
    if (product.type == DownloadProductType.audio) {
      currentPack = recentAudiosPack;
    } else {
      currentPack = recentScriptsPack;
    }
    when(testEnvironment.repositories
            .at<DownloadableProductsRepository>()
            .getDownloadStatusFor(currentPack.products))
        .thenAnswer((_) async => [downloadable]);
    when(testEnvironment.repositories.at<SessionsRepository>().getSession())
        .thenAnswer((_) => Future.value(Session.mocked()));
    if (product.type == DownloadProductType.audio) {
      when(testEnvironment.repositories.at<SessionsRepository>().audios)
          .thenReturn([downloadable.item]);
      when(testEnvironment.repositories.at<SessionsRepository>().scripts)
          .thenReturn([]);
    } else {
      when(testEnvironment.repositories.at<SessionsRepository>().scripts)
          .thenReturn([downloadable.item]);
      when(testEnvironment.repositories.at<SessionsRepository>().audios)
          .thenReturn([]);
    }
    when(testEnvironment.repositories
            .at<DownloadableProductsRepository>()
            .startReceivingDownloadStatus())
        .thenAnswer((_) => ReceivePort());
  }

  Future<void> openScriptsTab(WidgetTester tester) async {
    await createWidgetFor(tester);
    await tester.pumpAndSettle();
    await tester.pressButtonWithText('Scripts');
  }

  group('Sessions page', () {
    group('ON “Audios” tab', () {
      setUp(() {
        mockInitialResponses(audio, DownloadTaskStatus.undefined.index);
      });
      group('IN “Recent audios” section', () {
        group('IF audio is not downloaded', () {
          setUp(() {
            mockInitialResponses(audio, DownloadTaskStatus.undefined.index);
          });
          testWidgets('THEN shows download button', (tester) async {
            // Setup
            await createWidgetFor(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byKey(const Key('Download')), findsWidgets);
          });
          group('IF user clicks on download button', () {
            testWidgets('THEN downloads audio', (tester) async {
              // Setup
              await createWidgetFor(tester);
              // Execution
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(const Key('Download')));
              // Validation
              verify(testEnvironment.repositories
                      .at<DownloadableProductsRepository>()
                      .requestDownload(downloadableFor(audio,
                          status: DownloadTaskStatus.undefined.index)))
                  .called(1);
            });
          });
        });
        group('IF audio is downloading', () {
          setUp(() {
            mockInitialResponses(audio, DownloadTaskStatus.running.index);
          });
          testWidgets('THEN shows progress indicator', (tester) async {
            // Setup
            await createWidgetFor(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byType(CircularPercentIndicator), findsWidgets);
          });
          testWidgets('THEN shows cancel button', (tester) async {
            // Setup
            await createWidgetFor(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byKey(const Key('Cancel')), findsWidgets);
          });
          group('IF user clicks on cancel button', () {
            testWidgets('THEN cancels audio download', (tester) async {
              // Setup
              await createWidgetFor(tester);
              // Execution
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(const Key('Cancel')));
              // Validation
              verify(testEnvironment.repositories
                      .at<DownloadableProductsRepository>()
                      .cancelDownload(downloadableFor(audio,
                          status: DownloadTaskStatus.running.index)))
                  .called(1);
            });
          });
        });
        group('IF audio is downloaded', () {
          setUp(() {
            mockInitialResponses(audio, DownloadTaskStatus.complete.index);
          });
          testWidgets('THEN shows menu button', (tester) async {
            // Setup
            await createWidgetFor(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byKey(const Key('Menu')), findsWidgets);
          });
          group('IF user clicks on delete button', () {
            testWidgets('THEN deletes audio', (tester) async {
              // Setup
              await createWidgetFor(tester);
              // Execution
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(const Key('Menu')));
              await tester.pumpAndSettle();
              await tester.tap(find.text('Delete'));
              await tester.pumpAndSettle();
              await tester.tap(find.text('Yes, delete'));
              // Validation
              verify(testEnvironment.repositories
                      .at<DownloadableProductsRepository>()
                      .delete(downloadableFor(audio,
                          status: DownloadTaskStatus.complete.index)))
                  .called(1);
            });
          });
        });
      });
    });
    group('ON “Scripts” tab', () {
      setUp(() {
        mockInitialResponses(script, DownloadTaskStatus.undefined.index);
      });
      group('IN “Recent scripts” section', () {
        group('IF script is not downloaded', () {
          setUp(() {
            mockInitialResponses(script, DownloadTaskStatus.undefined.index);
          });
          testWidgets('THEN shows download button', (tester) async {
            // Setup
            await openScriptsTab(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byKey(const Key('Download')), findsWidgets);
          });
          group('IF user clicks on download button', () {
            testWidgets('THEN downloads script', (tester) async {
              // Setup
              await openScriptsTab(tester);
              // Execution
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(const Key('Download')));
              // Validation
              verify(testEnvironment.repositories
                      .at<DownloadableProductsRepository>()
                      .requestDownload(downloadableFor(script,
                          status: DownloadTaskStatus.undefined.index)))
                  .called(1);
            });
          });
        });
        group('IF script is downloading', () {
          setUp(() {
            mockInitialResponses(script, DownloadTaskStatus.running.index);
          });
          testWidgets('THEN shows progress indicator', (tester) async {
            // Setup
            await openScriptsTab(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byType(CircularPercentIndicator), findsWidgets);
          });
          testWidgets('THEN shows cancel button', (tester) async {
            // Setup
            await openScriptsTab(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byKey(const Key('Cancel')), findsWidgets);
          });
          group('IF user clicks on cancel button', () {
            testWidgets('THEN cancels script download', (tester) async {
              // Setup
              await openScriptsTab(tester);
              // Execution
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(const Key('Cancel')));
              // Validation
              verify(testEnvironment.repositories
                      .at<DownloadableProductsRepository>()
                      .cancelDownload(downloadableFor(script,
                          status: DownloadTaskStatus.running.index)))
                  .called(1);
            });
          });
        });
        group('IF script is downloaded', () {
          setUp(() {
            mockInitialResponses(script, DownloadTaskStatus.complete.index);
          });
          testWidgets('THEN shows menu button', (tester) async {
            // Setup
            await openScriptsTab(tester);
            // Validation
            await tester.pumpAndSettle();
            expect(find.byKey(const Key('Menu')), findsWidgets);
          });
          group('IF user clicks on delete button', () {
            testWidgets('THEN deletes script', (tester) async {
              // Setup
              await openScriptsTab(tester);
              // Execution
              await tester.pumpAndSettle();
              await tester.tap(find.byKey(const Key('Menu')));
              await tester.pumpAndSettle();
              await tester.tap(find.text('Delete'));
              await tester.pumpAndSettle();
              await tester.tap(find.text('Yes, delete'));
              // Validation
              verify(testEnvironment.repositories
                      .at<DownloadableProductsRepository>()
                      .delete(downloadableFor(script,
                          status: DownloadTaskStatus.complete.index)))
                  .called(1);
            });
          });
        });
      });
      group('IF user clicks on script', () {
        testWidgets('THEN navigates to Document Viewer page', (tester) async {
          // Setup
          await openScriptsTab(tester);
          // Execution
          await tester.pressButtonWithText(script.name);
          // Validation
          await tester.pump();
          expect(find.byType(DocumentViewerPage), findsOneWidget);
        });
      });
    });
  });
}
