import 'package:flutter/material.dart';

class PageIndexProvider extends ChangeNotifier {
  int _activeIndex = 0;
  int _previousIndex = 0;

  int get activeIndex => _activeIndex;
  int get previousIndex => _previousIndex;

  void setActiveIndex({required int activeIndex}) {
    _activeIndex = activeIndex;

    notifyListeners();
  }

  void navigateToListenTab() {
    _previousIndex = _activeIndex;
    _activeIndex = 1;
    notifyListeners();
  }

  void navigateToPreviousTab() {
    _activeIndex = _previousIndex;
    notifyListeners();
  }
}
