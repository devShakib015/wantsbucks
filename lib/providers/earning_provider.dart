import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class EarningProvider extends ChangeNotifier {
  final _currentUserEarningCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("earnings");

  Future<int> getCurrentBalance() async {
    int _earning = 0;
    try {
      await _currentUserEarningCollection.get().then((value) {
        int _currentEarning = value.docs.first.data()["currentBalance"];
        _earning = _currentEarning;
      });
    } catch (e) {
      _earning = 0;
    }
    return _earning;
  }

  Future<void> addProfit(int newProfit) async {
    await _currentUserEarningCollection.get().then((value) async {
      int _currentEarning = value.docs.first.data()["currentBalance"];
      int _totalEarning = value.docs.first.data()["totalEarning"];
      await _currentUserEarningCollection.doc("earning").update({
        "currentBalance": _currentEarning + newProfit,
        "totalEarning": _totalEarning + newProfit,
      });
    });

    notifyListeners();
  }

  void reduceProfit(int newpoint) async {
    await _currentUserEarningCollection.get().then((value) async {
      int _currentProfit = value.docs.first.data()["currentBalance"];
      await _currentUserEarningCollection.doc("earning").update({
        "currentBalance": _currentProfit - newpoint,
      });
    });
    notifyListeners();
  }
}
