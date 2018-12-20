import 'package:flutter/material.dart';
import 'package:flutter_app1/components/VideoList.dart';
import 'package:flutter_app1/views/base/BaseAliveState.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseAliveState<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        width: double.infinity,
        height: double.infinity,
        child: new VideoList(),
      ),
    );
  }
}
