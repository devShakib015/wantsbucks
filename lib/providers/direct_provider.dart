import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DirectProvider extends ChangeNotifier {
  Future<QuerySnapshot> getJoinedAccount() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("refferedBy", isEqualTo: FirebaseAuth.instance.currentUser.email)
        .get();
  }

  Future<int> getCurrentDirectAmount() async {
    int _directAmount = 0;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("directs")
          .doc("direct")
          .get()
          .then((value) {
        int _currentBal = value.data()["currentBalance"];
        _directAmount = _currentBal.toInt();
      });
    } catch (e) {
      _directAmount = 0;
    }
    return _directAmount;
  }
}
