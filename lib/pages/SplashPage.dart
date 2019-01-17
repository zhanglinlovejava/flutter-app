import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'MainPage.dart';
import 'dart:async';
import 'package:flutter_open/api/API.dart';
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  TabList _homeTabList;

  @override
  void initState() {
    super.initState();
    _fetchHomeTabList();
    _timerToMain();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Image(
      image: AssetImage(
        'asset/images/splash_image.jpg',
      ),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ));
  }

  _fetchHomeTabList() async {
      await HttpController.getInstance().get(API.HOME_TAB, (data) {
        _homeTabList = TabList.map(data['tabInfo']['tabList']);
      }, token: 'SplashHomeTab');
  }
  _timerToMain() {
    new Timer(Duration(seconds: 2), () {
      HttpController.getInstance().cancelRequest('SplashHomeTab');
      HttpController.getInstance().cancelRequest('SplashCommunityTab');
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) {
        return new MainPage(_homeTabList);
      }), (Route<dynamic> route) => false);
    });
  }
}
