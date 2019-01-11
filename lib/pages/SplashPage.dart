import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'package:flutter_open/db/DBManager.dart';
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
  TabList _communityTabList;
  DBManager _db = DBManager();

  @override
  void initState() {
    super.initState();
    _fetchHomeTabList();
    _fetchCommunityTabList();
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
    TabList tabList = await _db.queryHomeTabList();
    if (tabList != null &&
        tabList.tabList != null &&
        tabList.tabList.length > 0) {
      _homeTabList = tabList;
    } else {
      await HttpController.getInstance().get(API.HOME_TAB, (data) {
        tabList = TabList.map(data['tabInfo']['tabList']);
        _homeTabList = tabList;
        _db.saveHomeTabList(tabList);
      }, token: 'SplashHomeTab');
    }
  }
  _fetchCommunityTabList() async{
    TabList tabList = await _db.queryCommunityTabList();
    if (tabList != null &&
        tabList.tabList != null &&
        tabList.tabList.length > 0) {
      _communityTabList = tabList;
    } else {
      await HttpController.getInstance().get(API.COMMUNITY_TAB, (data) {
        tabList = TabList.map(data['tabInfo']['tabList']);
        _communityTabList = tabList;
        _db.saveCommunityTabList(tabList);
      }, token: 'SplashCommunityTab');
    }
  }
  _timerToMain() {
    new Timer(Duration(seconds: 2), () {
      HttpController.getInstance().cancelRequest('SplashHomeTab');
      HttpController.getInstance().cancelRequest('SplashCommunityTab');
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) {
        return new MainPage(_homeTabList,_communityTabList);
      }), (Route<dynamic> route) => false);
    });
  }
}
