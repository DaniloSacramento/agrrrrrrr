import 'package:flutter/material.dart';

class DivergenceProvider with ChangeNotifier {
  dynamic item;

  DivergenceProvider({required this.item});

  void updateItem(dynamic newItem) {
    item = newItem;
    notifyListeners();
  }
}
