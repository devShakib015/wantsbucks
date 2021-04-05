import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wantsbucks/models/transfer_model.dart';

class TransferProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _transferCollection =
      FirebaseFirestore.instance.collection("transfers");
  final _userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> transferAmount(String to, int amount) async {
    try {
      await _userCollection
          .doc(_firebaseAuth.currentUser.uid)
          .collection("directs")
          .get()
          .then((value) async {
        int _currentDirect = value.docs.first.data()["currentBalance"];
        await _userCollection
            .doc(_firebaseAuth.currentUser.uid)
            .collection("directs")
            .doc("direct")
            .update({
          "currentBalance": _currentDirect - amount,
        });
      });

      await _userCollection
          .where("email", isEqualTo: to)
          .get()
          .then((value) async {
        final _toUserID = value.docs.first.id;
        await _userCollection
            .doc(_toUserID)
            .collection("directs")
            .get()
            .then((value) async {
          int _currentDirect = value.docs.first.data()["currentBalance"];
          int _totalDirect = value.docs.first.data()["totalBalance"];
          await _userCollection
              .doc(_toUserID)
              .collection("directs")
              .doc("direct")
              .update({
            "currentBalance": _currentDirect + amount,
            "totalBalance": _totalDirect + amount,
          });
        });
      });

      await _transferCollection.add(TransferModel(
              time: DateTime.now(),
              from: _firebaseAuth.currentUser.email,
              to: to,
              amount: amount)
          .toMap());
    } catch (e) {}
  }

  Future<QuerySnapshot> getTransfersFromMe() async {
    return await _transferCollection
        .where("from", isEqualTo: _firebaseAuth.currentUser.email)
        .get();
  }

  Future<QuerySnapshot> getTransfersTOMe() async {
    return await _transferCollection
        .where("to", isEqualTo: _firebaseAuth.currentUser.email)
        .get();
  }
}
