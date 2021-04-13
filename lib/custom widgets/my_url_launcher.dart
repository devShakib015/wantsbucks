import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> callPhone(String number) async {
  if (await canLaunch("tel://$number")) {
    await launch(
      "tel://$number",
    );
  } else {
    throw 'Could not launch $number';
  }
}
