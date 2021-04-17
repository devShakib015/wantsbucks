import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/constants.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/withdraw_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class DrawingsList extends StatefulWidget {
  @override
  _DrawingsListState createState() => _DrawingsListState();
}

class _DrawingsListState extends State<DrawingsList> {
  BannerAd _ad;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: withdraw_list_banner,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawings"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<WithdrawProvider>(context).getWithdrawls(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                } else if (snapshot.hasError) {
                  return SomethingWentWrong();
                } else {
                  final _d = snapshot.data.docs;
                  List<QueryDocumentSnapshot> _data = List.from(_d.reversed);
                  if (_data.isEmpty) {
                    return Center(
                      child: Text("No withdrawls made yet."),
                    );
                  } else
                    return ListView(
                      children: _data
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Text("${_d.indexOf(e) + 1}"),
                                  subtitle: e.data()["status"] == "pending"
                                      ? Text(
                                          "Requested: ${customDateFormat(DateTime.fromMillisecondsSinceEpoch(e.data()["requestTime"]))}")
                                      : e.data()["status"] == "cancelled"
                                          ? Text(
                                              "Requested: ${customDateFormat(DateTime.fromMillisecondsSinceEpoch(e.data()["requestTime"]))}")
                                          : Text(
                                              "Requested: ${customDateFormat(DateTime.fromMillisecondsSinceEpoch(e.data()["requestTime"]))}\nCompleted: ${customDateFormat(DateTime.fromMillisecondsSinceEpoch(e.data()["completedTime"]))}"),
                                  tileColor: e.data()["status"] == "pending"
                                      ? Colors.blueGrey
                                      : e.data()["status"] == "cancelled"
                                          ? dangerColor
                                          : Color(0xff2ba965),
                                  title: Text(
                                    "Amount: ${e.data()["amount"]}",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: e.data()["status"] == "pending"
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      dangerColor)),
                                          onPressed: () {
                                            _cancelWithdraw(context, e);
                                          },
                                          child: Text("Cancel"))
                                      : null,
                                ),
                              ))
                          .toList(),
                    );
                }
              },
            )),
            CustomBannerAd(
              ad: _ad,
            ),
          ],
        ),
      ),
    );
  }

  void _cancelWithdraw(BuildContext context, QueryDocumentSnapshot e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("Are you sure to cancel this request?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);

                      Provider.of<WithdrawProvider>(context, listen: false)
                          .cancelWithdraw(e.id);

                      Provider.of<EarningProvider>(context, listen: false)
                          .addProfitFromCancellingWithdraw(
                              (e.data()["amount"] / 0.96).toInt());
                      Provider.of<EarningProvider>(context, listen: false)
                          .reduceFromWithdrew(e.data()["amount"]);
                    },
                    child: Text("Sure")),
              ],
            ));
  }
}
