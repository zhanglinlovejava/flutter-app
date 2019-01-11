import 'package:flutter/material.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() {
    return _MinePageState();
  }
}

class _MinePageState extends BaseAliveSate<MinePage> {
  @override
  Widget build(BuildContext context) {
    return new Center(child: Text("mine"));
  }
}
