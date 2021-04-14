import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/constants.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/user_provider.dart';

import 'package:wantsbucks/theming/color_constants.dart';

class Bonuses extends StatefulWidget {
  final int totalPoint;
  final int totalDirects;

  const Bonuses({
    Key key,
    @required this.totalPoint,
    @required this.totalDirects,
  }) : super(key: key);

  @override
  _BonusesState createState() => _BonusesState();
}

class _BonusesState extends State<Bonuses> {
  BannerAd _ad;
  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: bonus_page_banner,
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
    List<int> _pointBonus = [20000, 50000, 100000, 200000, 300000, 500000];
    List<Map<String, int>> _refferalBonus = [
      {
        "direct": 100,
        "bonus": 100,
      },
      {
        "direct": 500,
        "bonus": 400,
      },
      {
        "direct": 2000,
        "bonus": 1500,
      },
      {
        "direct": 5000,
        "bonus": 3000,
      },
      {
        "direct": 10000,
        "bonus": 5000,
      },
      {
        "direct": 25000,
        "bonus": 15000,
      },
      {
        "direct": 50000,
        "bonus": 25000,
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bonuses"),
          bottom: TabBar(
            labelColor: mainColor,
            tabs: [
              Tab(
                text: "Referral Bonus",
              ),
              Tab(
                text: "Point Bonus",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: FutureBuilder<List>(
                    future:
                        Provider.of<UserProvider>(context).getClaimedBonuses(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: Text("Loading..."));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error!"));
                      } else {
                        final _bonusData = snapshot.data;

                        return TabBarView(
                          children: [
                            _referBonusTab(_refferalBonus, _bonusData, context),
                            _pointBonusTab(_pointBonus, _bonusData, context),
                          ],
                        );
                      }
                    })),
            CustomBannerAd(
              ad: _ad,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointBonusTab(
      List<int> _pointBonus, List _bonusData, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text("Total Points: ${widget.totalPoint}"),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: _pointBonus
                .map((e) => Padding(
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
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Congrats!".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "5% of",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: _bonusData.contains("pb$e")
                                  ? Colors.blueGrey
                                  : widget.totalPoint < e
                                      ? Color(0xffab0e22)
                                      : Color(0xff2ba965),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                              "$e",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ))),
                        footer: widget.totalPoint < e
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "points to get this Bonus!\n(5%)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : _bonusData.contains("pb$e")
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
                                            MaterialStateProperty.all(white),
                                      ),
                                      onPressed: () async {
                                        setState(() {});
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .claimPointBonus(e);

                                        await Provider.of<EarningProvider>(
                                                context,
                                                listen: false)
                                            .addProfit(
                                          (e * (5 / 100)).toInt(),
                                        );
                                      },
                                      child: Text(
                                        "Claim",
                                        style: TextStyle(
                                          color: Color(0xff2ba965),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _referBonusTab(List<Map<String, int>> _refferalBonus, List _bonusData,
      BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text("Total Directs: ${widget.totalDirects}"),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: _refferalBonus
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridTile(
                        header: widget.totalDirects < e["direct"]
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Refer Total",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Congrats!".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _bonusData.contains("rb${e["direct"]}")
                                ? Colors.blueGrey
                                : widget.totalDirects < e["direct"]
                                    ? Color(0xffab0e22)
                                    : Color(0xff2ba965),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                              child: widget.totalDirects < e["direct"]
                                  ? Text(
                                      "${e["direct"]}",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "You referred ${e["direct"]} users\nYou get BDT ${e["bonus"]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ),
                        footer: widget.totalDirects < e["direct"]
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Users to get this Bonus!\n(BDT - ${e["bonus"]})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : _bonusData.contains("rb${e["direct"]}")
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
                                            MaterialStateProperty.all(white),
                                      ),
                                      onPressed: () async {
                                        setState(() {});
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .claimReferBonus(e["direct"]);

                                        await Provider.of<EarningProvider>(
                                                context,
                                                listen: false)
                                            .addProfit(
                                          (e["bonus"]).toInt(),
                                        );
                                      },
                                      child: Text(
                                        "Claim",
                                        style: TextStyle(
                                          color: Color(0xff2ba965),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
