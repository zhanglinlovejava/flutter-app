import 'package:flutter/material.dart';
import 'package:flutter_app1/components/List.dart';

class FirstPage extends StatefulWidget {
  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new List(),
      ),
    );
  }
}
