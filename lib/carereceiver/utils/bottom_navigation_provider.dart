import 'package:flutter/foundation.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int page = 0;
  void updatePage(int index) {
    // print("Page Index $index");
    page = index;
    notifyListeners();
  }
}
