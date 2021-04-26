import 'package:flutter/material.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(
            "Email: wantsbro@gmail.com",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          SelectableText(
            "Phone: 014020513851",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          SelectableText(
            "Phone 2: 01710265421",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () async {
              await launchURL("https://www.facebook.com/wantsbucksagnt");
            },
            child: Container(
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "FaceBook Page",
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
