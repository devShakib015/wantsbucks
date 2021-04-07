import 'package:wantsbucks/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/request_withdraw.dart';
import 'package:wantsbucks/other_pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/user_provider.dart';

const _textStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w900,
);

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15),
          child: PointAndEarning(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WBSettings()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<int>(
                future:
                    Provider.of<EarningProvider>(context).getCurrentBalance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Loading();
                  } else if (snapshot.hasError) {
                    return SomethingWentWrong();
                  } else {
                    final _earning = snapshot.data;
                    return Container(
                      child: FutureBuilder<DocumentSnapshot>(
                        future:
                            Provider.of<UserProvider>(context).getUserDetails(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Loading();
                          } else if (snapshot.hasError) {
                            return SomethingWentWrong();
                          } else {
                            final _data = snapshot.data.data();
                            final _joiningDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    _data["joiningDate"]);
                            final _dueDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    _data["dueDate"]);

                            final _reRegisterDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    _data["reRegisterDate"]);

                            final _dayLeft =
                                _dueDate.difference(DateTime.now()).inDays;
                            return SingleChildScrollView(
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _profileSection(_data),
                                    _activityWidget(
                                        context,
                                        _data,
                                        _earning,
                                        _dayLeft,
                                        _joiningDate,
                                        _dueDate,
                                        _reRegisterDate),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                }),
          ),
          SizedBox(
            height: 60,
            child: Center(
              child: Text("Banner Ad"),
            ),
          ),
        ],
      ),
    );
  }

  Container _profileSection(Map<String, dynamic> _data) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(8),
              width: 85,
              child: Image.asset(
                "assets/images/avatar.png",
                fit: BoxFit.cover,
              )),
          SizedBox(
            width: 10,
          ),
          Text(
            _data["name"],
            textAlign: TextAlign.center,
            style: _textStyle,
          ),
          Text(
            _data["phone"],
            textAlign: TextAlign.center,
            style: _textStyle,
          ),
          Text(
            _data["email"],
            textAlign: TextAlign.center,
            style: _textStyle,
          ),
          Text(
            "Directed By: ${_data["refferedBy"]}",
            textAlign: TextAlign.center,
            style: _textStyle,
          ),
        ],
      ),
    );
  }

  Container _activityWidget(
      BuildContext context,
      Map<String, dynamic> _data,
      int _earning,
      int _dayLeft,
      DateTime _joiningDate,
      DateTime _dueDate,
      DateTime _reRegisterDate) {
    int _totalPayable = 50;

    if (_dayLeft <= -30) {
      _totalPayable = -(_dayLeft) + 20;
    }
    return Container(
      decoration: BoxDecoration(
          color: _dayLeft <= 0 ? Color(0xffb21d13) : Color(0xff2aa965),
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Joined",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    customDateFormat(_joiningDate),
                    style: _textStyle,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Date",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    customDateFormat(_dueDate),
                    style: _textStyle,
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 130,
            child: Center(
              child: _dayLeft <= 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Suspended!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Total Payable: $_totalPayable "),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Activated!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_dayLeft == 1
                            ? "$_dayLeft day left"
                            : "$_dayLeft days left"),
                      ],
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Re-Activated",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    customDateFormat(_reRegisterDate),
                    style: _textStyle,
                  ),
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  Colors.white,
                )),
                onPressed: _dayLeft <= 0
                    ? () async {
                        //Reactivation
                        if (_earning < _totalPayable) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "You don't have sufficient balance to reactivate.\nEarn first!")));
                        } else {
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                        "$_totalPayable taka will be charged from profit to reactivate your account. Are you sure about it?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Provider.of<EarningProvider>(
                                                    context,
                                                    listen: false)
                                                .reduceProfit(_totalPayable);
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .reactivatedUser(
                                                    _data["dueDate"]);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Sure")),
                                    ],
                                  ));
                        }
                      }
                    : () {
                        //Withdraw
                        if (_earning < 300) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "You must have at least 300 taka to withdraw.")));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RequestWithdraw(currentProfit: _earning),
                            ),
                          );
                        }
                      },
                child: _dayLeft <= 0
                    ? Text(
                        "Re-Activate",
                        style: TextStyle(
                            color: Color(0xffb21d13),
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Withdraw",
                        style: TextStyle(
                            color: Color(0xff2aa965),
                            fontWeight: FontWeight.bold),
                      ),
              )
            ],
          )
        ],
      ),
    );
  }
}
