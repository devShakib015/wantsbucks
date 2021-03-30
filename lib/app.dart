import 'package:flutter/material.dart';
import 'package:wantsbucks/other_pages/loading.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: Text("Button")),
      ),
    );
  }
}
