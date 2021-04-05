import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/providers/auth_provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : SingleChildScrollView(
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
                        height: 120,
                      ),
                      Text(
                        "Register New User",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Can't be empty";
                          } else if (value.length < 3) {
                            return "Name must be at least 3 Characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Clark Kent",
                          labelText: "Name",
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Can't be empty";
                          } else if (value.length < 11 || value.length > 11) {
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Can't be empty";
                          } else if (!value.contains("@") ||
                              !value.contains(".")) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "kent345@gmail.com",
                          labelText: "Email",
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
                          hintText: "Anything you can remember",
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
                            // final user =
                            //     await Future.delayed(Duration(seconds: 3));
                            final _registered = await Provider.of<AuthProvider>(
                                    context,
                                    listen: false)
                                .register(
                                    context,
                                    _emailController.text,
                                    _phoneController.text,
                                    _nameController.text,
                                    _passController.text);
                            if (!_registered) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        child: Text(
                          "Register",
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
          );
  }
}
