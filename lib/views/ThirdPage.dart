import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  @override
  ThirdPageState createState() => ThirdPageState();
}

class ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("这是第三个界面"),
      ),
    );
  }
}
