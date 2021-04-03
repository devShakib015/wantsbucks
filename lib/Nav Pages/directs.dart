import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/Auth%20Pages/register.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/providers/direct_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';
import 'package:wantsbucks/theming/theme.dart';

class Direct extends StatelessWidget {
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
                                builder: (context) => _registerProvider()));
                      },
              ),
              appBar: AppBar(
                title: Text("Directs"),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(15),
                  child: Container(
                    child: Text("Balace: $_data"),
                  ),
                ),
              ),
              body: Container(
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
                        return ListView(
                          children: _d
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: ListTile(
                                    leading:
                                        Text("${_directsList.indexOf(e) + 1}"),
                                    tileColor: mainColor,
                                    title: Text(e.data()["email"]),
                                  ),
                                ),
                              )
                              .toList(),
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

  Widget _registerProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'wantsBucks_login',
        debugShowCheckedModeBanner: false,
        theme: mainTheme,
        home: Register(),
      ),
    );
  }
}
