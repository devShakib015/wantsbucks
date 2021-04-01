import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wantsbucks/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance.collection("users");

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> register(
      BuildContext context, String email, String password) async {
    UserCredential userCredential;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        await _userCollection.doc(userCredential.user.uid).set(
              UserModel(
                      email: email,
                      name: null,
                      refferedBy: _firebaseAuth.currentUser.email)
                  .toMap(),
            );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The user is registered Successfully.")));
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("There is already an user exists with this email.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("There is an error registering new user.")));
      }
    }
    await app.delete();
    notifyListeners();
    return Future.sync(() => userCredential);
  }

  Future<UserCredential> signIn(
      BuildContext context, String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
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

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
