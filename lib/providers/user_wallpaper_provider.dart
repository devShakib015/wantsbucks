import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserWallpaperProvider extends ChangeNotifier {
  final _currentUserWallpaperCollection = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("wallpapers");

  Future<QuerySnapshot> getUnlockedLevels() async {
    return await _currentUserWallpaperCollection.get();
  }
}
