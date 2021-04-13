import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/constants.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/providers/transfer_provider.dart';
import 'package:wantsbucks/providers/user_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class TransferMoney extends StatefulWidget {
  final int currentAmount;
  const TransferMoney({
    Key key,
    @required this.currentAmount,
  }) : super(key: key);

  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  BannerAd _ad;

  @override
  void initState() {
    super.initState();

    //TODO: - Add Banner Ad
    _ad = BannerAd(
      adUnitId: admob_test_banner,
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
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Transfer Direct Amount"),
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
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  } else if (!value.contains("@") ||
                                      !value.contains(".")) {
                                    return "Invalid Email";
                                  } else if (_emailController.text.trim() ==
                                      FirebaseAuth.instance.currentUser.email) {
                                    return "You can't send money to your account!";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: "kent345@gmail.com",
                                  labelText: "Reciever's Email",
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  } else if (int.tryParse(value) == null) {
                                    return "Invalid number";
                                  } else if (int.parse(value) % 50 != 0) {
                                    return "The amount must be a multiple of 50.";
                                  } else if (int.parse(value) >
                                      widget.currentAmount) {
                                    return "You don't have enough balance!!";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.monetization_on),
                                  hintText: "500",
                                  labelText: "Amount",
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
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    bool _doesUserExists =
                                        await Provider.of<UserProvider>(context,
                                                listen: false)
                                            .doesUserExists(
                                                _emailController.text.trim());
                                    if (_doesUserExists) {
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
                                                "Your Password is not right!! Or there is no internet connection."),
                                          ),
                                        );
                                      } else {
                                        await Provider.of<TransferProvider>(
                                                context,
                                                listen: false)
                                            .transferAmount(
                                                _emailController.text.trim(),
                                                int.parse(
                                                    _amountController.text));
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: dangerColor,
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                              "There is no user with this email."),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  "Transfer",
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
                CustomBannerAd(
                  ad: _ad,
                )
              ],
            ),
          );
  }
}
