import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DashboardProvider extends ChangeNotifier {
  final _currentUserEarningCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("earnings");

  final _currentUserPointCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("points");

  final _currentUserDirectCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("directs");

  Future<Map<String, dynamic>> getAllInfos() async {
    Map<String, dynamic> _infos = {
      "totalEarning": 0,
      "currentEarning": 0,
      "totalPoint": 0,
      "currentPoint": 0,
      "totalDirect": 0,
      "currentDirect": 0,
      "totalDirectPersons": 0,
      "withdrews": null,
    };
    try {
      await _currentUserEarningCollection.get().then((value) {
        int _currentEarning = value.docs.first.data()["currentBalance"];
        int _totalEarning = value.docs.first.data()["totalEarning"];
        List _withdrews = value.docs.first.data()["withdrew"];
        _infos["currentEarning"] = _currentEarning;
        _infos["totalEarning"] = _totalEarning;
        _infos["withdrews"] = _withdrews;
      });
      await _currentUserPointCollection.get().then((value) {
        int _currentPoint = value.docs.first.data()["currentPoint"];
        int _totalPoint = value.docs.first.data()["totalPoint"];
        _infos["currentPoint"] = _currentPoint;
        _infos["totalPoint"] = _totalPoint;
      });

      await _currentUserDirectCollection.get().then((value) {
        int _currentDirect = value.docs.first.data()["currentBalance"];
        int _totalDirect = value.docs.first.data()["totalBalance"];
        _infos["currentDirect"] = _currentDirect;
        _infos["totalDirect"] = _totalDirect;
      });
      await FirebaseFirestore.instance
          .collection("users")
          .where("refferedBy",
              isEqualTo: FirebaseAuth.instance.currentUser.email)
          .get()
          .then((value) {
        int _totalDirect = value.docs.length;
        _infos["totalDirectPersons"] = _totalDirect;
      });
    } catch (e) {}
    return _infos;
  }
}
