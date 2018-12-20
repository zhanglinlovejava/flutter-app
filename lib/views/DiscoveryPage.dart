import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1/views/base/BaseAliveState.dart';
import 'package:flutter_app1/views/FollowPage.dart';
import 'package:flutter_app1/views/CategoryPage.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  DiscoveryPageState createState() => DiscoveryPageState();
}

class DiscoveryPageState extends BaseAliveState<DiscoveryPage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  int _currentIndex = 0;
  VoidCallback onChange;
  var titles = <String>['关注', '分类'];
  static const plaform = MethodChannel('example.flutter.io/battery-level');
  String _batteryLevel = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await plaform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at ${result}%';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level :${e.message}';
      print('${e.message}---------e.details');
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  DiscoveryPageState() {
    controller = new TabController(length: 2, vsync: this);
    onChange = () {
      setState(() {
        _currentIndex = controller.index;
      });
    };
    controller.addListener(onChange);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("发现"),
        centerTitle: true,
        bottom: new TabBar(
          indicatorColor: Colors.black,
          tabs: <Widget>[
            new Tab(
              text: "关注",
            ),
            new Tab(text: "分类")
          ],
          controller: controller,
        ),
      ),
      body: new TabBarView(
        children: <Widget>[new FollwPage(), new CategoryPage()],
        controller: controller,
        physics: new NeverScrollableScrollPhysics(),
      ),
    );
  }
}
