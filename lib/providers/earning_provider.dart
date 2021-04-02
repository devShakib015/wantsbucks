import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class EarningProvider extends ChangeNotifier {
  final _currentUserEarningCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("earnings");

  Future<double> getCurrentBalance() async {
    double _earning = 0;
    try {
      await _currentUserEarningCollection.get().then((value) {
        double _currentEarning = value.docs.first.data()["currentBalance"];
        _earning = _currentEarning.toDouble();
      });
    } catch (e) {
      _earning = 0;
    }
    return _earning;
  }

  Future<void> addProfit(double newProfit) async {
    await _currentUserEarningCollection.get().then((value) async {
      double _currentEarning =
          value.docs.first.data()["currentBalance"].toDouble();
      double _totalEarning = value.docs.first.data()["totalEarning"].toDouble();
      await _currentUserEarningCollection.doc("earning").update({
        "currentBalance": _currentEarning + newProfit,
        "totalEarning": _totalEarning + newProfit,
      });
    });

    notifyListeners();
  }
}
