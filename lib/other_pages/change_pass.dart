import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Change Password"),
            ),
            body: Container(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _currentPassController,
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
                        labelText: "Current Password",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _newPassController,
                      obscureText: true,
                      validator: (value) {
                        // print("Change Password");
                        //
                        //     user.reauthenticateWithCredential(_credential);
                        // user.updatePassword("jskdjhj");
                        if (value.isEmpty) {
                          return "Can't be empty";
                        } else if (value.length < 6) {
                          return "Password is at least 6 characters.";
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelText: "New Password",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _confirmPassController,
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
                        labelText: "Confirm New Password",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            AuthCredential _credential =
                                EmailAuthProvider.credential(
                                    email:
                                        FirebaseAuth.instance.currentUser.email,
                                    password: _currentPassController.text);
                            var userCred;
                            try {
                              userCred = await FirebaseAuth.instance.currentUser
                                  .reauthenticateWithCredential(_credential);
                            } catch (e) {
                              userCred = null;
                            }

                            if (userCred == null) {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: dangerColor,
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                          "Current Password is not right!!")));
                            } else {
                              if (_newPassController.text !=
                                  _confirmPassController.text) {
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: dangerColor,
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        "Confirm password is not right! Try it again.")));
                              } else {
                                await FirebaseAuth.instance.currentUser
                                    .updatePassword(
                                        _confirmPassController.text);
                                _confirmPassController.clear();
                                _newPassController.clear();
                                _currentPassController.clear();
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Password is changed successfully!")));
                              }
                            }
                            //print("Done!!");
                          }
                        },
                        child: Text("Change Password")),
                  ],
                ),
              ),
            ),
          );
  }
}
