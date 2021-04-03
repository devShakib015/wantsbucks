import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wantsbucks/models/user_model.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class AuthProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance.collection("users");

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> register(
      BuildContext context, String email, String password) async {
    final _currentUserDirectCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("directs");
    final _currentUserEarningCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("earnings");

    UserCredential userCredential;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        await _userCollection.doc(userCredential.user.uid).set(
              UserModel(
                      email: email, refferedBy: _firebaseAuth.currentUser.email)
                  .toMap(),
            );
        await _userCollection
            .doc(userCredential.user.uid)
            .collection("wallpapers")
            .doc("level 0")
            .set({
          "items": [],
        });
        await _userCollection
            .doc(userCredential.user.uid)
            .collection("points")
            .doc("point")
            .set({
          "currentPoint": 0,
          "totalPoint": 0,
        });
        await _userCollection
            .doc(userCredential.user.uid)
            .collection("earnings")
            .doc("earning")
            .set({
          "currentBalance": 0,
          "totalEarning": 0,
          "withdrew": [],
        });
        await _userCollection
            .doc(userCredential.user.uid)
            .collection("directs")
            .doc("direct")
            .set({
          "currentBalance": 0,
          "totalBalance": 0,
        });
        await _currentUserDirectCollection.get().then((value) async {
          int _currentBal = value.docs.first.data()["currentBalance"];
          await _currentUserDirectCollection.doc("direct").update({
            "currentBalance": _currentBal - 50,
          });
        });
        await _currentUserEarningCollection.get().then((value) async {
          int _currentEarning = value.docs.first.data()["currentBalance"];
          int _totalEarning = value.docs.first.data()["totalEarning"];
          await _currentUserEarningCollection.doc("earning").update({
            "currentBalance": _currentEarning + 5,
            "totalEarning": _totalEarning + 5,
          });
        });
        await Future.delayed(Duration(seconds: 1));
        Phoenix.rebirth(context);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: dangerColor,
            duration: Duration(seconds: 1),
            content: Text("There is already an user exists with this email.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: dangerColor,
            duration: Duration(seconds: 1),
            content: Text("There is an error registering new user.")));
      }
    }
    await app.delete();
    return Future.sync(() => userCredential);
  }

  Future<UserCredential> signIn(
      BuildContext context, String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Phoenix.rebirth(context);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found for that email.")));
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong password provided for that user.")));
      }
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Phoenix.rebirth(context);
  }
}
