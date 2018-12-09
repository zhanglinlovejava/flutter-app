import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("这是第二个界面"),
      ),
    );
  }
}
