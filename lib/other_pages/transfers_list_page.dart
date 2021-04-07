import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/transfer_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class TransfersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Transfers"),
          bottom: TabBar(
            labelColor: mainColor,
            tabs: [
              Tab(
                icon: Icon(Icons.arrow_upward),
                text: "Paid",
              ),
              Tab(
                icon: Icon(Icons.arrow_downward),
                text: "Received",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future: Provider.of<TransferProvider>(context)
                        .getTransfersFromMe(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Loading();
                      } else if (snapshot.hasError) {
                        return SomethingWentWrong();
                      } else {
                        final _d = snapshot.data.docs;

                        List<QueryDocumentSnapshot> _data =
                            List.from(_d.reversed);

                        if (_data.isEmpty) {
                          return Center(child: Text("No Transaction"));
                        } else
                          return ListView(
                            children: _data.map((e) {
                              final _date = customDateFormat(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      e.data()["time"]));
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: ListTile(
                                  tileColor: mainColor,
                                  leading: Text("${_data.indexOf(e) + 1}"),
                                  trailing: Text("${e.data()["amount"]}"),
                                  title: Text(e.data()["to"]),
                                  subtitle: Text("Date: $_date"),
                                ),
                              );
                            }).toList(),
                          );
                      }
                    },
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: Provider.of<TransferProvider>(context)
                        .getTransfersTOMe(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Loading();
                      } else if (snapshot.hasError) {
                        return SomethingWentWrong();
                      } else {
                        final _d = snapshot.data.docs;
                        List<QueryDocumentSnapshot> _data =
                            List.from(_d.reversed);
                        if (_data.isEmpty) {
                          return Center(child: Text("No Transaction"));
                        } else
                          return ListView(
                            children: _data.map((e) {
                              final _date = customDateFormat(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      e.data()["time"]));
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: ListTile(
                                  tileColor: mainColor,
                                  leading: Text("${_data.indexOf(e) + 1}"),
                                  trailing: Text("${e.data()["amount"]}"),
                                  title: Text(e.data()["from"]),
                                  subtitle: Text("Date: $_date"),
                                ),
                              );
                            }).toList(),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: Center(
                child: Text("Banner Ad"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
