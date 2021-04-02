import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class LevelProvider extends ChangeNotifier {
  final _wallpapersCollection =
      FirebaseFirestore.instance.collection("wallpapers");

  Future<QuerySnapshot> getLevelWallpapers(String levelID) async {
    final _levelItemsCollection =
        _wallpapersCollection.doc(levelID).collection("items");
    return await _levelItemsCollection.get();
  }
}
