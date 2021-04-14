// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:wantsbucks/custom%20widgets/custom_banner_ad.dart';
// import 'package:wantsbucks/other_pages/loading.dart';
// import 'package:wantsbucks/theming/color_constants.dart';

// class TopUp extends StatefulWidget {
//   @override
//   _TopUpState createState() => _TopUpState();
// }

// class _TopUpState extends State<TopUp> {
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _amountController = TextEditingController();
//   TextEditingController _passController = TextEditingController();
//   BannerAd _ad;

//   @override
//   void initState() {
//     super.initState();

//     _ad = BannerAd(
//       adUnitId: "ca-app-pub-3940256099942544/8865242552",
//       size: AdSize.banner,
//       request: AdRequest(),
//       listener: AdListener(
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//         },
//       ),
//     );
//     _ad.load();
//   }

//   @override
//   void dispose() {
//     _ad?.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Loading()
//         : Scaffold(
//             appBar: AppBar(
//               title: Text("Top Up Direct Amount"),
//             ),
//             body: Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusScope.of(context).requestFocus(FocusNode());
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         width: double.infinity,
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Center(
//                                     child: Text(
//                                       "You should send the money first to our account then top up from here.\nWhen you send the amount in our account, please use reference code as\n'WB-TOPUP [ your_email ]'",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Center(
//                                     child: SelectableText(
//                                       "Send Money to -\nNagad: 01700000000\nBkash: 01700000000\nRocket: 01700000000",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               TextFormField(
//                                 controller: _amountController,
//                                 keyboardType: TextInputType.number,
//                                 validator: (value) {
//                                   if (value.isEmpty) {
//                                     return "Can't be empty";
//                                   } else if (int.tryParse(value) == null) {
//                                     return "Invalid number";
//                                   } else if (int.parse(value) % 50 != 0) {
//                                     return "The amount must be a multiple of 50.";
//                                   } else if (int.parse(value) < 500) {
//                                     return "Minimum amount is 500!!";
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.monetization_on),
//                                   hintText: "500",
//                                   labelText: "Amount",
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               TextFormField(
//                                 keyboardType: TextInputType.visiblePassword,
//                                 controller: _passController,
//                                 obscureText: true,
//                                 validator: (value) {
//                                   if (value.isEmpty) {
//                                     return "Can't be empty";
//                                   } else if (value.length < 6) {
//                                     return "Password is at least 6 characters.";
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.security),
//                                   hintText: "Your Secured password",
//                                   labelText: "Password",
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   if (_formKey.currentState.validate()) {
//                                     setState(() {
//                                       _isLoading = true;
//                                     });

//                                     AuthCredential _credential =
//                                         EmailAuthProvider.credential(
//                                             email: FirebaseAuth
//                                                 .instance.currentUser.email,
//                                             password: _passController.text);
//                                     var userCred;
//                                     try {
//                                       userCred = await FirebaseAuth
//                                           .instance.currentUser
//                                           .reauthenticateWithCredential(
//                                               _credential);
//                                     } catch (e) {
//                                       userCred = null;
//                                     }
//                                     if (userCred == null) {
//                                       setState(() {
//                                         _isLoading = false;
//                                       });
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                           backgroundColor: dangerColor,
//                                           duration: Duration(seconds: 1),
//                                           content: Text(
//                                               "Your Password is not right!!"),
//                                         ),
//                                       );
//                                     } else {

//                                       print("You can top up now!");
//                                       setState(() {
//                                         _isLoading = false;
//                                       });
//                                       Navigator.pop(context);
//                                     }
//                                   }
//                                 },
//                                 child: Text(
//                                   "Top Up",
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(
//                                     EdgeInsets.symmetric(
//                                       vertical: 12,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 CustomBannerAd(
//                   ad: _ad,
//                 )
//               ],
//             ),
//           );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';

class TopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Up"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Currently we don't have top up service.\n If you need direct money you can contact our agents.\n They will help you to get this. Thank you!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text("Agent 1:")),
                GestureDetector(
                  onTap: () async {
                    await launchURL("https://m.me/mahin7673/");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("Text on Messenger")),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await callPhone("01676598513");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("Direct Call")),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(child: Text("Agent 2:")),
                GestureDetector(
                  onTap: () async {
                    await launchURL("https://m.me/venomShakib/");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("Text on Messenger")),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await callPhone("01710265421");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("Direct Call")),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
