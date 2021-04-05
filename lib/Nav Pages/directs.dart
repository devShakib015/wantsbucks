import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/Auth%20Pages/register.dart';
import 'package:wantsbucks/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/other_pages/topup.dart';
import 'package:wantsbucks/other_pages/transfer_money.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/providers/direct_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';
import 'package:wantsbucks/theming/theme.dart';

class Direct extends StatefulWidget {
  @override
  _DirectState createState() => _DirectState();
}

class _DirectState extends State<Direct> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: Provider.of<DirectProvider>(context).getCurrentDirectAmount(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          } else if (snapshot.hasError) {
            return SomethingWentWrong();
          } else {
            final _data = snapshot.data;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                tooltip: "Join New User",
                onPressed: _data == 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _registerProvider(context),
                          ),
                        );
                      },
              ),
              appBar: AppBar(
                  title: Text("Directs"),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(25),
                    child: Container(
                      child: Text(
                        "Balance: $_data",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  leading: MaterialButton(
                    minWidth: 30,
                    child: Container(
                        width: 30,
                        child: Image.asset(
                          "assets/images/topup.png",
                          fit: BoxFit.cover,
                        )),
                    onPressed: () {
                      //Topup
                      //TODO: Make Topup System
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopUp(),
                        ),
                      );
                    },
                  ),
                  actions: [
                    MaterialButton(
                      minWidth: 55,
                      child: Container(
                          width: 30,
                          child: Image.asset(
                            "assets/images/money_transfer.png",
                            fit: BoxFit.cover,
                          )),
                      onPressed: _data == 0
                          ? null
                          : () async {
                              //Transfer
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransferMoney(
                                    currentAmount: _data,
                                  ),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                    ),
                  ]),
              body: Container(
                margin: EdgeInsets.only(top: 10),
                child: FutureBuilder<QuerySnapshot>(
                  future:
                      Provider.of<DirectProvider>(context).getJoinedAccount(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Loading();
                    } else if (snapshot.hasError) {
                      return SomethingWentWrong();
                    } else {
                      final _directsList = snapshot.data.docs;
                      var _d = _directsList.reversed.toList();
                      if (_directsList.isEmpty) {
                        return Center(child: Text("You didn't join any user."));
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: _d.map((e) {
                                  var _date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          e.data()["joiningDate"]);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: ListTile(
                                      leading: Text(
                                          "${_directsList.indexOf(e) + 1}"),
                                      tileColor: mainColor,
                                      title: Text(e.data()["name"]),
                                      subtitle: Text(
                                          "${e.data()["email"]}\n${customDateFormat(_date)}"),
                                      isThreeLine: true,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Center(
                                child: Text("Banner Ad"),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            );
          }
        });
  }

  Widget _registerProvider(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          title: 'wantsBucks_login',
          debugShowCheckedModeBanner: false,
          theme: mainTheme,
          home: Scaffold(
            appBar: AppBar(
              title: Text("Registration"),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: Register(),
          ),
        ));
  }
}
