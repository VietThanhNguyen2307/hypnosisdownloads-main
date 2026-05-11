import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/pack_details_page.dart';
import 'package:mockito/mockito.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../test_commons.dart';
import '../test_environment.dart';

void main() {
  final testEnvironment = TestEnvironment();

  ProductPack productPackExample =
      ProductPack.mocked().copyWith(name: 'Example product pack');
  const productExampleName = 'Example product';
  final productExample = Product.mocked(productExampleName);
  const productExampleLink = 'https://example.com/product';
  Downloadable<Product> downloadableUndefined = Downloadable(
    item: productExample,
    name: productExampleName,
    onlineUrl: productExampleLink,
    status: DownloadTaskStatus.undefined.index,
  );
  Downloadable<Product> downloadableRunning = Downloadable(
    item: productExample,
    name: productExampleName,
    onlineUrl: productExampleLink,
    status: DownloadTaskStatus.running.index,
  );
  Downloadable<Product> downloadableComplete = Downloadable(
    item: productExample,
    name: productExampleName,
    onlineUrl: productExampleLink,
    status: DownloadTaskStatus.complete.index,
  );

  Future<void> createWidgetFor(WidgetTester tester) async {
    return await testEnvironment.openWith(
        tester, PackDetailsPage(packDetails: productPackExample));
  }

  void mockInitialResponses(int status) {
    final downloadable = [
      downloadableUndefined,
      downloadableRunning,
      downloadableComplete
    ].firstWhere((element) => element.status == status);
    when(testEnvironment.repositories
            .at<DownloadableProductsRepository>()
            .getDownloadStatusFor(productPackExample.products))
        .thenAnswer((_) async => [downloadable]);
    when(testEnvironment.repositories
            .at<DownloadableProductsRepository>()
            .startReceivingDownloadStatus())
        .thenAnswer((_) => ReceivePort());
  }

  group('Pack details page', () {
    setUp(() {
      mockInitialResponses(DownloadTaskStatus.undefined.index);
    });
    group('IF user clicks on “Download all” button', () {
      testWidgets('THEN shows “Do you want to download all files?” popup',
          (tester) async {
        // Setup
        await createWidgetFor(tester);
        // Execution
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('Download all')));
        // Validation
        await tester.pumpAndSettle();
        tester.confirmTextShown('Do you want to download all files?');
      });
      group('IF user confirms', () {
        testWidgets('THEN downloads audios', (tester) async {
          // Setup
          await createWidgetFor(tester);
          // Execution
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('Download all')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Yes'));
          // Validation
          verify(testEnvironment.repositories
                  .at<DownloadableProductsRepository>()
                  .requestDownload(downloadableUndefined))
              .called(1);
        });
      });
    });
    group('IF user checks “Download all” toggle', () {
      testWidgets('THEN shows “Do you want to download all files?” popup',
          (tester) async {
        // Setup
        await createWidgetFor(tester);
        // Execution
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FlutterSwitch));
        // Validation
        await tester.pumpAndSettle();
        tester.confirmTextShown('Do you want to download all files?');
      });
      group('IF user confirms', () {
        testWidgets('THEN downloads audios', (tester) async {
          // Setup
          await createWidgetFor(tester);
          // Execution
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FlutterSwitch));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Yes'));
          // Validation
          verify(testEnvironment.repositories
                  .at<DownloadableProductsRepository>()
                  .requestDownload(downloadableUndefined))
              .called(1);
        });
      });
    });
    group('IF audio is not downloaded', () {
      setUp(() {
        mockInitialResponses(DownloadTaskStatus.undefined.index);
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
                  .requestDownload(downloadableUndefined))
              .called(1);
        });
      });
    });
    group('IF audio is downloading', () {
      setUp(() {
        mockInitialResponses(DownloadTaskStatus.running.index);
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
                  .cancelDownload(downloadableRunning))
              .called(1);
        });
      });
    });
    group('IF audio is downloaded', () {
      setUp(() {
        mockInitialResponses(DownloadTaskStatus.complete.index);
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
                  .delete(downloadableComplete))
              .called(1);
        });
      });
    });
  });
}
