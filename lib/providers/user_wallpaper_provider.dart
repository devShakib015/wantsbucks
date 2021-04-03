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

  Future<DocumentSnapshot> getUnlockedWallpapers(String levelID) async {
    return await _currentUserWallpaperCollection.doc(levelID).get();
  }

  void addBoughtWallpaper(String levelID, String wallpaperID) async {
    await _currentUserWallpaperCollection
        .doc(levelID)
        .get()
        .then((value) async {
      List _items = value.data()["items"];
      List _newItems = _items + [wallpaperID];
      await _currentUserWallpaperCollection.doc(levelID).update({
        "items": _newItems,
      });
    });
    notifyListeners();
  }

  void addNewUnlockedWallpaper(String unlockedLevelID) async {
    await _currentUserWallpaperCollection
        .doc(unlockedLevelID)
        .set({'items': []});
    notifyListeners();
  }
}
