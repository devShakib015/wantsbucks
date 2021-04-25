import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';
import 'package:wantsbucks/other_pages/about.dart';
import 'package:wantsbucks/other_pages/change_pass.dart';
import 'package:wantsbucks/other_pages/contact.dart';
import 'package:wantsbucks/other_pages/edit_profile.dart';
import 'package:wantsbucks/other_pages/guidelines.dart';
import 'package:wantsbucks/other_pages/privacy.dart';
import 'package:wantsbucks/providers/auth_provider.dart';
import 'package:wantsbucks/theming/color_constants.dart';
import 'package:package_info/package_info.dart';

class WBSettings extends StatefulWidget {
  final String name;
  final String phone;
  const WBSettings({
    Key key,
    @required this.name,
    @required this.phone,
  }) : super(key: key);

  @override
  _WBSettingsState createState() => _WBSettingsState();
}

class _WBSettingsState extends State<WBSettings> {
  String _appVersion = '';
  // BannerAd _ad;

  // @override
  // void initState() {
  //   super.initState();
  //   _ad = BannerAd(
  //     adUnitId: settings_banner,
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: AdListener(
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _ad.load();
  // }

  // @override
  // void dispose() {
  //   _ad?.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationVersion: _appVersion,
                    applicationLegalese: "From wantsBro",
                    applicationIcon: Container(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        "assets/images/logo/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    applicationName: "wantsBucks",
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(text: "Developed By: "),
                          TextSpan(
                              text: "devShakib",
                              style: TextStyle(color: Colors.lightBlue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launchURL(
                                      "https://www.facebook.com/venomShakib/");
                                }),
                        ])),
                      ),
                    ]);
              }),
        ],
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                    name: widget.name, phone: widget.phone)));
                      }
                    },
                    title: Text("Edit Profile"),
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
                  Divider(
                    height: 40,
                    thickness: 2,
                  ),
                  ListTile(
                    tileColor: Color(0xff8f3aaf),
                    onTap: () async {
                      {
                        //TODO: Add GuideLines
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Guidelines()));
                      }
                    },
                    title: Text("Guidelines"),
                    leading: Icon(Icons.book),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    tileColor: Color(0xff505ce3),
                    onTap: () async {
                      {
                        //TODO: Add about
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => About()));
                      }
                    },
                    title: Text("About WB"),
                    leading: Icon(Icons.corporate_fare),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    tileColor: Color(0xff1674c7),
                    onTap: () async {
                      {
                        //TODO: Add Contact
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Contact()));
                      }
                    },
                    title: Text("Contact WB"),
                    leading: Icon(Icons.contact_phone),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    tileColor: Color(0xff5b2570),
                    onTap: () async {
                      {
                        //TODO: Add Privacy
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Privacy()));
                      }
                    },
                    title: Text("Privacy Policy"),
                    leading: Icon(Icons.policy),
                  ),
                  Divider(
                    height: 40,
                    thickness: 2,
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
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container();
              } else {
                String appName = snapshot.data.appName;
                // String packageName = snapshot.data.packageName;
                String version = snapshot.data.version;
                _appVersion = version;
                // String buildNumber = snapshot.data.buildNumber;

                return Container(
                  child: Column(
                    children: [
                      Text(
                        "from wantsBro".toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "version: $version".toUpperCase(),
                        style: TextStyle(
                          color: disableWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Copyright © ${DateTime.now().year}, $appName"
                            .toUpperCase(),
                        style: TextStyle(
                          color: disableWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          // CustomBannerAd(
          //   ad: _ad,
          // ),
        ],
      ),
    );
  }
}
