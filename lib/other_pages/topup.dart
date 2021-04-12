import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class TopUp extends StatefulWidget {
  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Top Up Direct Amount"),
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
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be empty";
                                  } else if (int.tryParse(value) == null) {
                                    return "Invalid number";
                                  } else if (int.parse(value) % 50 != 0) {
                                    return "The amount must be a multiple of 50.";
                                  } else if (int.parse(value) < 500) {
                                    return "Minimum amount is 500!!";
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
                                              "Your Password is not right!!"),
                                        ),
                                      );
                                    } else {
                                      //TODO: TopUp
                                      print("You can top up now!");
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Text(
                                  "Top Up",
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
                CustomBannerAd()
              ],
            ),
          );
  }
}
