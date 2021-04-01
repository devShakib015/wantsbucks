import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class WallpaperProvider extends ChangeNotifier {
  final _wallpaperCollection =
      FirebaseFirestore.instance.collection("wallpapers");

  Future<QuerySnapshot> getAllLevels() async {
    return await _wallpaperCollection.get();
  }
}
