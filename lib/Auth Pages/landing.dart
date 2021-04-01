import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/Auth%20Pages/login.dart';
import 'package:wantsbucks/app.dart';
import 'package:wantsbucks/other_pages/loading.dart';
import 'package:wantsbucks/providers/auth_provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Provider.of<AuthProvider>(context).getUser(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        //          ⇐ NEW
        if (snapshot.connectionState == ConnectionState.done) {
          // log error to console                                            ⇐ NEW
          if (snapshot.error != null) {
            print("error");
            return Text(snapshot.error.toString());
          }
          // redirect to the proper page, pass the user into the
          // `HomePage` so we can display the user email in welcome msg     ⇐ NEW
          return snapshot.hasData ? App() : Login();
        } else {
          // show loading indicator                                         ⇐ NEW
          return Loading();
        }
      },
    );
  }
}
