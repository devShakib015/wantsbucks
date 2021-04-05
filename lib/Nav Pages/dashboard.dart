import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/other_pages/transfers_list_page.dart';
import 'package:wantsbucks/providers/dashboard_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: Provider.of<DashboardProvider>(context).getAllInfos(),
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Loading();
                  } else if (snapshot.hasError) {
                    return SomethingWentWrong();
                  } else {
                    final _data = snapshot.data;

                    return Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDashboardCard(
                                    data: _data['currentEarning'],
                                    color: Color(0xff2ba965),
                                    title: "Current Profit"),
                                CustomDashboardCard(
                                    data: _data['totalEarning'],
                                    color: Color(0xff5c3d92),
                                    title: "Total Profit"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDashboardCard(
                                    data: _data['totalDirectPersons'],
                                    color: Color(0xffe52265),
                                    title: "Total Directs"),
                                CustomDashboardCard(
                                    data: ((_data['totalEarning'] -
                                                _data["currentEarning"]) *
                                            (95 / 100))
                                        .toInt(),
                                    color: Color(0xff0d4582),
                                    title: "Total Withdrawls"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDashboardCard(
                                    data: _data['currentPoint'],
                                    color: Color(0xff14a4d9),
                                    title: "Current Point"),
                                CustomDashboardCard(
                                    data: _data['totalPoint'],
                                    color: Color(0xffb20038),
                                    title: "Total Point"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDashboardCard(
                                    data: _data['currentDirect'],
                                    color: Color(0xfff64718),
                                    title: "Current Direct Amount"),
                                CustomDashboardCard(
                                    data: _data['totalDirect'],
                                    color: Color(0xff402ba3),
                                    title: "Total Direct Amount"),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                //Bonuses
                                //TODO: Make Top Up list
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: Colors.blue,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    width: double.infinity,
                                    child: Text(
                                      "Top Ups",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Bonuses
                                //TODO: Make Drawings List
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: Color(0xff8a2e7f),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    width: double.infinity,
                                    child: Text(
                                      "Drawings",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //Bonuses
                                //TODO: Make Bonus System
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: Color(0xff2ba965),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    width: double.infinity,
                                    child: Text(
                                      "Bonuses",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TransfersList()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: dangerColor,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    width: double.infinity,
                                    child: Text(
                                      "Transfers",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
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

class CustomDashboardCard extends StatelessWidget {
  final int data;
  final Color color;
  final String title;
  const CustomDashboardCard({
    Key key,
    @required this.data,
    @required this.color,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: color,
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 24,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "$data",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
