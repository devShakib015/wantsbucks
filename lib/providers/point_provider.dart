import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PointProvider extends ChangeNotifier {
  final _currentUserPointCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("points");

  Future<int> getCurrentPoints() async {
    int _point = 0;
    try {
      await _currentUserPointCollection.get().then((value) {
        int _currentPoint = value.docs.first.data()["currentPoint"];
        _point = _currentPoint.toInt();
      });
    } catch (e) {
      _point = 0;
    }
    return _point;
  }

  void reducePoint(int newpoint) async {
    try {
      await _currentUserPointCollection.get().then((value) async {
        int _currentPoint = value.docs.first.data()["currentPoint"];
        await _currentUserPointCollection.doc("point").update({
          "currentPoint": _currentPoint - newpoint,
        });
      });
    } catch (e) {}

    notifyListeners();
  }

  Future<void> addPoint(int newpoint) async {
    try {
      await _currentUserPointCollection.get().then((value) async {
        int _currentPoint = value.docs.first.data()["currentPoint"];
        int _totalPoint = value.docs.first.data()["totalPoint"];
        await _currentUserPointCollection.doc("point").update({
          "currentPoint": _currentPoint + newpoint,
          "totalPoint": _totalPoint + newpoint,
        });
      });
    } catch (e) {}

    notifyListeners();
  }
}
