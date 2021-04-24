import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/providers/earning_provider.dart';
import 'package:wantsbucks/providers/withdraw_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class RequestWithdraw extends StatefulWidget {
  final int currentProfit;
  const RequestWithdraw({
    Key key,
    @required this.currentProfit,
  }) : super(key: key);

  @override
  _RequestWithdrawState createState() => _RequestWithdrawState();
}

class _RequestWithdrawState extends State<RequestWithdraw> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _methodController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  int _originalWithdraw = 0;
  // BannerAd _ad;

  // @override
  // void initState() {
  //   super.initState();
  //   _ad = BannerAd(
  //     adUnitId: request_withdraw_banner,
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: AdListener(
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _ad.load();
  // }

  // @override
  // void dispose() {
  //   _ad?.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Request Withdraw"),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(15),
                child: Center(
                  child: Text("Profit: ${widget.currentProfit}"),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                        // height: MediaQuery.of(context).size.height - 120,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  } else if (value.length < 11 ||
                                      value.length > 11) {
                                    return "Phone must be 11 numbers";
                                  } else if (int.tryParse(value) == null) {
                                    return "Invalid number";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  hintText: "01700000000",
                                  labelText: "Phone",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: _methodController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.payment),
                                  hintText: "BKash, Nagad, Rocket",
                                  labelText: "Payment Method",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: _typeController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.assignment_ind),
                                  hintText: "Agent, Personal",
                                  labelText: "Account Type",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    int _v = int.tryParse(value) ?? 0;
                                    _originalWithdraw =
                                        (_v * (95 / 100)).toInt();
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  } else if (int.tryParse(value) == null) {
                                    return "Invalid number";
                                  } else if (int.parse(value) >
                                      widget.currentProfit) {
                                    return "You don't have enough balance!!";
                                  } else if (int.parse(value) < 300) {
                                    return "Minimum withdrawl amount is 300.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.monetization_on),
                                  hintText: "300",
                                  labelText: "Amount",
                                  suffixText: "$_originalWithdraw",
                                  helperText:
                                      "5% will be deducted as withdraw charge!",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passController,
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  } else if (value.length < 6) {
                                    return "Password is at least 6 characters.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.security),
                                  hintText: "Your Secured password",
                                  labelText: "Password",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    int _amount =
                                        (int.parse(_amountController.text) *
                                                (95 / 100))
                                            .toInt();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    AuthCredential _credential =
                                        EmailAuthProvider.credential(
                                            email: FirebaseAuth
                                                .instance.currentUser.email,
                                            password: _passController.text);
                                    var userCred;
                                    try {
                                      userCred = await FirebaseAuth
                                          .instance.currentUser
                                          .reauthenticateWithCredential(
                                              _credential);
                                    } catch (e) {
                                      userCred = null;
                                    }
                                    if (userCred == null) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: dangerColor,
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                              "Your Password is not right or There is no internet Connection!!!"),
                                        ),
                                      );
                                    } else {
                                      await Provider.of<WithdrawProvider>(
                                              context,
                                              listen: false)
                                          .requestWithdraw(
                                        accountType: _typeController.text,
                                        paymentMethod: _methodController.text,
                                        amount: _amount,
                                        phone: _phoneController.text,
                                      );
                                      Provider.of<EarningProvider>(context,
                                              listen: false)
                                          .reduceProfit(int.parse(
                                              _amountController.text));
                                      Provider.of<EarningProvider>(context,
                                              listen: false)
                                          .addToWithdraw(_amount);
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Text(
                                  "Request",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // CustomBannerAd(
                //   ad: _ad,
                // )
              ],
            ),
          );
  }
}
