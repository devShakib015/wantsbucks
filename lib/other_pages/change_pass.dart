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
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            prefixIcon: Icon(Icons.security),
                            hintText: "Your Current Password",
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
                            if (value.isEmpty) {
                              return "Can't be empty";
                            } else if (value.length < 6) {
                              return "Password is at least 6 characters.";
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.security),
                            hintText: "The new password you want to set",
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
                            prefixIcon: Icon(Icons.security),
                            hintText:
                                "The new password you just gave one step before this.",
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
                                      email: FirebaseAuth
                                          .instance.currentUser.email,
                                      password: _currentPassController.text);
                              var userCred;
                              try {
                                userCred = await FirebaseAuth
                                    .instance.currentUser
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
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
                                          "Password is changed successfully!"),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Text("Update New Password"),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
