import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/theming/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      mainColor,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return _isLoading
        ? Loading()
        : Scaffold(
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
                        AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Welcome to wantsBucks',
                              textAlign: TextAlign.center,
                              textStyle: GoogleFonts.lobsterTwo(
                                textStyle: TextStyle(
                                    color: mainColor,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold),
                              ),
                              colors: colorizeColors,
                            ),
                          ],
                          repeatForever: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Login",
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
                              final user =
                                  await Future.delayed(Duration(seconds: 3));
                              // final user = await Provider.of<AuthProvider>(context,
                              //         listen: false)
                              //     .login(context, _emailController.text,
                              //         _passController.text);
                              if (user == null) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Login",
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
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            onPressed: () {},
                            child: Text("Forgot Password? Reset Here!"))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}