import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:loader_overlay/loader_overlay.dart';

extension TestCommons on WidgetTester {
  static String errorMessage = 'Error message';

  void confirmTextShown(String text, {bool isExactMatch = false}) {
    expect(findText(text, isExactMatch), findsWidgets);
  }

  void confirmTextNotShown(String text, {bool isExactMatch = false}) {
    expect(findText(text, isExactMatch), findsNothing);
  }

  void confirmWidgetShown(Type type) {
    expect(find.byType(type), findsWidgets);
  }

  void confirmLoadingIndicatorShown() {
    expect(find.byType(LoadingView), findsWidgets);
  }

  void confirmLoadingIndicatorShownIn(BuildContext context) {
    expect(context.loaderOverlay.visible, true);
  }

  Future<void> pressButtonWithText(String text,
      {bool isExactMatch = false}) async {
    // Use hitTestWarningShouldBeFatal = true when this is fixed: https://github.com/flutter/flutter/issues/100758
    WidgetController.hitTestWarningShouldBeFatal = false;
    final button = findText(text, isExactMatch);
    await ensureVisible(button);
    await tap(button);
    await pump(); // Don't use pumpAndSettle(), to be able to test dialogs. Use it explicitly afterwards, if opening pages.
  }

  Future<void> pressButtonWithKey(Key key) async {
    // Use hitTestWarningShouldBeFatal = true when this is fixed: https://github.com/flutter/flutter/issues/100758
    WidgetController.hitTestWarningShouldBeFatal = false;
    final button = find.byKey(key);
    await ensureVisible(button);
    await tap(button);
    await pump(); // Don't use pumpAndSettle(), to be able to test dialogs. Use it explicitly afterwards, if opening pages.
  }

  Future<void> pressButtonWithImage(String assetName) async {
    // Use hitTestWarningShouldBeFatal = true when this is fixed: https://github.com/flutter/flutter/issues/100758
    WidgetController.hitTestWarningShouldBeFatal = false;
    final button = find.widgetWithImage(IconButton, AssetImage(assetName));
    await ensureVisible(button);
    await tap(button);
    await pump();
  }

  Future<void> input(String hint, String text) async {
    final inputField = find.bySemanticsLabel(hint);
    await enterText(inputField, text);
  }

  BuildContext get context => element(find.byType(MaterialApp));

  Finder findText(String text, bool isExactMatch) {
    if (isExactMatch) {
      return find.text(text);
    } else {
      return find.textContaining(text);
    }
  }
}
