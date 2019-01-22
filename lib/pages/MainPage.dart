import 'package:flutter/material.dart';
import '../component/IconTap.dart';
import 'package:flutter_open/pages/HomePage.dart';
import './MinePage.dart';
import '../entity/TabList.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import '../pages/CommonTabListPage.dart';
import '../api/API.dart';
import '../utils/ActionViewUtils.dart';
import '../event/EventUtils.dart';
import 'dart:async';
import '../event/Events.dart';

const int INDEX_HOME = 0;
const int INDEX_COMMUNITY = 1;
const int INDEX_NOTIFICATION = 2;
const int INDEX_MY = 3;

class MainPage extends StatefulWidget {
  final TabList homeTabList;
  final TabList communityTabList;

  MainPage(this.homeTabList, this.communityTabList);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BaseAliveSate<MainPage>
    with SingleTickerProviderStateMixin {
  int last = 0;
  TabController controller;
  VoidCallback onChange;
  int _currentIndex = 0;
  var titles = <String>['首页', '社区', '通知', '我的'];
  StreamSubscription<UpdateMainTabEvent> _streamSubscription;

  initState() {
    super.initState();
    controller = new TabController(length: 4, vsync: this);
    onChange = () {
      setState(() {
        _currentIndex = controller.index;
      });
    };
    controller.addListener(onChange);
    _streamSubscription =
        EventUtils.on<UpdateMainTabEvent>((UpdateMainTabEvent event) {
      if (_currentIndex != 0) controller.animateTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new HomePage(
            widget.homeTabList,
            type: 'home',
            index: 1,
          ),
          new HomePage(widget.communityTabList, type: 'cpmmunity'),
          new CommonTabListPage(API.MESSAGE_TAB,
              title: 'notification', type: 'message'),
          new MinePage()
        ],
        controller: controller,
        physics: new NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: new TabBar(
            controller: controller,
            indicatorColor: Colors.transparent,
            tabs: <Widget>[
              new IconTap(
                icon: _currentIndex == INDEX_HOME
                    ? 'asset/images/tab_home_s.png'
                    : 'asset/images/tab_home_n.png',
                color: _currentIndex == INDEX_HOME ? Colors.black : Colors.grey,
                text: titles[INDEX_HOME],
              ),
              new IconTap(
                icon: _currentIndex == INDEX_COMMUNITY
                    ? 'asset/images/tab_follow_s.png'
                    : 'asset/images/tab_follow_n.png',
                color: _currentIndex == INDEX_COMMUNITY
                    ? Colors.black
                    : Colors.grey,
                text: titles[INDEX_COMMUNITY],
              ),
              new IconTap(
                icon: _currentIndex == INDEX_NOTIFICATION
                    ? 'asset/images/tab_notification_s.png'
                    : 'asset/images/tab_notification_n.png',
                color: _currentIndex == INDEX_NOTIFICATION
                    ? Colors.black
                    : Colors.grey,
                text: titles[INDEX_NOTIFICATION],
              ),
              new IconTap(
                icon: _currentIndex == INDEX_MY
                    ? 'asset/images/tab_mine_s.png'
                    : 'asset/images/tab_mine_n.png',
                color: _currentIndex == INDEX_MY ? Colors.black : Colors.grey,
                text: titles[INDEX_MY],
              )
            ]),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
