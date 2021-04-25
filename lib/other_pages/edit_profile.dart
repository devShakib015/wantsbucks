import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/providers/user_provider.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String phone;
  const EditProfile({
    Key key,
    @required this.name,
    @required this.phone,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Edit Profile"),
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
                        SizedBox(
                          height: 26,
                        ),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Can't be empty";
                            } else if (value.length < 3) {
                              return "Must be at least 3 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: "Clark Kent",
                            labelText: "Name",
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
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
                            labelText: "Phone Number",
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

                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .updateProfile(
                                      name: _nameController.text,
                                      phone: _phoneController.text);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Update Profile",
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
