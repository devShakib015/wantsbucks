import 'package:wantsbucks/custom%20widgets/custom_date_format.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/other_pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/point_and_earning.dart';
import 'package:wantsbucks/other_pages/something_went_wrong.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/user_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

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
                            //final _dueDate = DateTime(2021, 2, 4);
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    _activityWidget(
                                        context,
                                        _earning,
                                        _dayLeft,
                                        _joiningDate,
                                        _dueDate,
                                        _reRegisterDate),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    _profileSection(_data),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 70,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data["name"],
                      style: _textStyle,
                    ),
                    Text(
                      _data["phone"],
                      style: _textStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _data["email"],
                  style: _textStyle,
                ),
                Text(
                  "Directed By: ${_data["refferedBy"]}",
                  style: _textStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _activityWidget(BuildContext context, int _earning, int _dayLeft,
      DateTime _joiningDate, DateTime _dueDate, DateTime _reRegisterDate) {
    int _totalPayable = 50;

    if (_dayLeft <= -30) {
      _totalPayable = -(_dayLeft);
    }
    return Container(
      decoration: BoxDecoration(
          color: _dayLeft <= 0 ? Color(0xffb21d13) : Color(0xff2aa965),
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(8),
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
                    ? () {
                        //Reactivation
                        if (_earning < 50) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "You need 50 taka to re-activate. Please earn first then try it.")));
                        } else {
                          //TODO: Make Reactivate System
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "You have to pay $_totalPayable taka to reactivate your account.")));
                        }
                      }
                    : () {
                        //Withdraw
                        if (_earning < 300) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "You must have at least 300 taka to withdraw.")));
                        } else {
                          //TODO: Make withdraw System
                          print("Able to withdraw");
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
