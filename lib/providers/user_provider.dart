import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  final _currentUserDocument = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid);

  Future<DocumentSnapshot> getUserDetails() {
    return _currentUserDocument.get();
  }

  Future<bool> doesUserExists(String email) async {
    bool _exists = false;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          _exists = true;
        }
      });
    } catch (e) {
      _exists = false;
    }
    return _exists;
  }

  Future<List> getClaimedBonuses() async {
    List _bonuses = [];
    await _currentUserDocument.collection("bonuses").get().then((value) {
      for (var item in value.docs) {
        _bonuses.add(item.data()["bonus"]);
      }
    });
    return _bonuses;
  }

  Future<void> claimBonus(int bonus) async {
    await _currentUserDocument.collection("bonuses").doc("$bonus").set({
      "bonus": bonus,
    });

    notifyListeners();
  }

  void reactivatedUser(int dueDate) async {
    DateTime _currentDate = DateTime.now();
    DateTime _pastDueDate = DateTime.fromMillisecondsSinceEpoch(dueDate);
    await _currentUserDocument.update({
      "reRegisterDate": _currentDate.millisecondsSinceEpoch,
      "dueDate": _pastDueDate.add(Duration(days: 91)).millisecondsSinceEpoch,
    });
    notifyListeners();
  }
}
