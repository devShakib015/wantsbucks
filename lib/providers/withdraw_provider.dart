import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wantsbucks/models/withdraw_model.dart';

class WithdrawProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _withdrawCollection =
      FirebaseFirestore.instance.collection("withdrawls");

  Future<void> requestWithdraw({
    String phone,
    String paymentMethod,
    String accountType,
    int amount,
  }) async {
    DateTime _currentTime = DateTime.now();

    try {
      await _withdrawCollection
          .doc("WD${_currentTime.millisecondsSinceEpoch}")
          .set(WithdrawModel(
            userId: _firebaseAuth.currentUser.uid,
            email: _firebaseAuth.currentUser.email,
            phone: phone,
            accountType: accountType,
            paymentMethod: paymentMethod,
            amount: amount,
            status: "pending",
            requestTime: _currentTime,
            completedTime: null,
          ).toMap());
    } catch (e) {
      print("errorrrrrrrrrrr");
      print(e);
    }
  }

  void cancelWithdraw(String id) async {
    try {
      await _withdrawCollection.doc(id).update({
        "status": "cancelled",
      });
    } catch (e) {
      print("errorrrrrrrrrrr");
      print(e);
    }
  }

  Future<QuerySnapshot> getWithdrawls() async {
    return await _withdrawCollection
        .where("email", isEqualTo: _firebaseAuth.currentUser.email)
        .get();
  }
}
