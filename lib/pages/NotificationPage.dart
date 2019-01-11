import 'package:flutter/material.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends BaseAliveSate<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(child: Text("notification"));
  }
}
