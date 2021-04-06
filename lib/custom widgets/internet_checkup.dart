import 'package:flutter/material.dart';
import 'package:wantsbucks/theming/theme.dart';

//! Showing Internet Connection is active or not

Widget internetConnectionWidget(BuildContext context) {
  return MaterialApp(
    theme: mainTheme,
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: (Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No internet connection."),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    ),
  );
}
