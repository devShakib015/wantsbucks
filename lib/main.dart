import 'package:flutter/material.dart';
import 'package:wantsbucks/theming/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      title: "wantsBucks",
      home: Scaffold(
        appBar: AppBar(
          title: Text('wantsBucks'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello Bangladesh'),
          ),
        ),
      ),
    );
  }
}
