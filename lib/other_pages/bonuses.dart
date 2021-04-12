import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/user_provider.dart';

import 'package:wantsbucks/theming/color_constants.dart';

class Bonuses extends StatefulWidget {
  final int totalPoint;

  const Bonuses({
    Key key,
    @required this.totalPoint,
  }) : super(key: key);

  @override
  _BonusesState createState() => _BonusesState();
}

class _BonusesState extends State<Bonuses> {
  @override
  Widget build(BuildContext context) {
    List<int> _bonuses = [20000, 50000, 100000, 200000, 300000, 500000];

    return Scaffold(
      appBar: AppBar(
        title: Text("Bonus"),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(15),
            child: Text("Total Point: ${widget.totalPoint}")),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                children: _bonuses
                    .map(
                      (e) => FutureBuilder<List>(
                        future: Provider.of<UserProvider>(context)
                            .getClaimedBonuses(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(child: Text("Loading..."));
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error!"));
                          } else {
                            final _bonusData = snapshot.data;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridTile(
                                header: widget.totalPoint < e
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "Earn Total",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "5% of",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: _bonusData.contains(e)
                                          ? Colors.blueGrey
                                          : widget.totalPoint < e
                                              ? Colors.blue
                                              : Color(0xff2ba965),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "$e",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ))),
                                footer: widget.totalPoint < e
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "points to get this Bonus!",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : _bonusData.contains(e)
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12),
                                            child: Text(
                                              "Already Claimed",
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          white),
                                                ),
                                                onPressed: () async {
                                                  setState(() {});
                                                  await Provider.of<
                                                              UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .claimBonus(e);

                                                  await Provider.of<
                                                              EarningProvider>(
                                                          context,
                                                          listen: false)
                                                      .addProfit((e * (5 / 100))
                                                          .toInt());
                                                },
                                                child: Text(
                                                  "Claim",
                                                  style: TextStyle(
                                                      color: Color(0xff2ba965)),
                                                )),
                                          ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          CustomBannerAd(),
        ],
      ),
    );
  }
}
