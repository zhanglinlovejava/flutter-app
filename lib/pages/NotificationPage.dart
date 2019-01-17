import 'package:flutter/material.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/pages/CommonListPage.dart';
import 'package:flutter_open/api/API.dart';
import '../Constants.dart';
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends BaseAliveSate<NotificationPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 30,
              child: Text(
                'Notification',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontFamily: ConsFonts.lobFont),
              ),
            ),
            Container(
              height: 34,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[200], width: 1))),
              padding: EdgeInsets.only(bottom: 3),
              child: TabBar(
                unselectedLabelColor: Colors.grey[500],
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.black,
                labelStyle: TextStyle(fontFamily: ConsFonts.fzFont, fontSize: 13),
                tabs: <Tab>[
                  Tab(
                    text: '通知',
                  ),
                  Tab(text: '互动')
                ],
                controller: _tabController,
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                CommonListPage(API.MESSAGE_LIST, type: 'message'),
                CommonListPage(API.INTERACT_LIST, type: 'message')
              ],
            ))
          ],
        ));
  }
}
