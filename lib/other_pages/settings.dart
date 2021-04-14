import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/constants.dart';
import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
import 'package:wantsbucks/other_pages/change_pass.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';

class WBSettings extends StatefulWidget {
  @override
  _WBSettingsState createState() => _WBSettingsState();
}

class _WBSettingsState extends State<WBSettings> {
  BannerAd _ad;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: settings_banner,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                                  "Your email is not verified. Please verify or your account will be suspended soon.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red)),
                              ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.currentUser
                                        .sendEmailVerification();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 8),
                                        content: Text(
                                            "The link is sent to your mail. Check and verify your mail. Then logout and login again to see the result. If you can't find the mail in your inbox, check spam or junk folder."),
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
                        //TODO: Add Change Account Info
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
                    tileColor: Color(0xff14a4d9),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                    },
                    title: Text("Change Password"),
                    leading: Icon(Icons.security),
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
                            .logOut(context);
                      }
                    },
                    title: Text("Logout"),
                    leading: Icon(Icons.logout),
                  ),
                ],
              ),
            ),
          ),
          CustomBannerAd(
            ad: _ad,
          ),
        ],
      ),
    );
  }
}
