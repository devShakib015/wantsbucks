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
}
