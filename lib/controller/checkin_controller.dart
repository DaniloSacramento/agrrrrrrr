import 'package:flutter/material.dart';
import 'package:trivia_checkin/model/checkin_model.dart';

class CheckinController extends ChangeNotifier {
  List<CheckIn> _checkinState = [];

  set value(List<CheckIn> params) {
    _checkinState = params;
    notifyListeners();
  }

  List<CheckIn> get value {
    return _checkinState;
  }

  Nota? _nota;

  Nota? get nota => _nota;

  void updateNota(Nota newNota) {
    _nota = newNota;
    notifyListeners();
  }
}
