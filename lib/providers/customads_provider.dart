import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CustomAdsProvider extends ChangeNotifier {
  final _homeAdsCollection = FirebaseFirestore.instance.collection("homeads");
  final _directAdsCollection =
      FirebaseFirestore.instance.collection("directads");
  final _earnAdsCollection = FirebaseFirestore.instance.collection("earnads");

  Future<QuerySnapshot> loadHomeAds() async {
    return await _homeAdsCollection.get();
  }

  Future<QuerySnapshot> loadDirectAds() async {
    return await _directAdsCollection.get();
  }

  Future<QuerySnapshot> loadEarnAds() async {
    return await _earnAdsCollection.get();
  }

  Future<void> addAds(String path, Map<String, dynamic> data) async {
    if (path == "homeads") {
      _homeAdsCollection.add(data);
    } else if (path == "directads") {
      _directAdsCollection.add(data);
    } else {
      _earnAdsCollection.add(data);
    }
  }
}
