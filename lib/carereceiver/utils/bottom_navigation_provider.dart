import 'package:flutter/foundation.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int page = 0;
  // int previousIndex = 0;
  void updatePage(int index) {
    page = index;
    // previousIndex = prePage;
    notifyListeners();
  }
}
