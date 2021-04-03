import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser.emailVerified);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: FirebaseAuth.instance.currentUser.emailVerified
                  ? Text(
                      "Your email is verified! Great!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    )
                  : Column(
                      children: [
                        Text(
                            "Your email is not verified. Please verify or your account will be suspened soon.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red)),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser
                                  .sendEmailVerification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Link is sent to your email. Check and verify your email. Then logout and login again to see the result."),
                                ),
                              );
                            },
                            child: Text("Verify Now")),
                      ],
                    ),
            ),
            ListTile(
              tileColor: mainColor,
              onTap: () async {
                {
                  print("Account");
                }
              },
              title: Text("Account"),
              leading: Icon(Icons.account_box),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              tileColor: dangerColor,
              onTap: () async {
                {
                  Navigator.pop(context);
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logOut();
                }
              },
              title: Text("Logout"),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
