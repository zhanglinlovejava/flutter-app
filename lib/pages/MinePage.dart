import 'package:flutter/material.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import '../utils/Tools.dart';
import '../utils/ActionViewUtils.dart';
import '../entity/TabInfo.dart';
import '../pages/StickyHeaderTabPage.dart';
import '../api/API.dart';
import 'CollectionPage.dart';
import '../pages/CommonTabListPage.dart';
import '../pages/CommonListPage.dart';
import '../Constants.dart';
import '../db/DBManager.dart';
import '../component/widgets/button/ShareBtnWidget.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() {
    return _MinePageState();
  }
}

class _MinePageState extends BaseAliveSate<MinePage> {
  List<TabInfo> _itemList = [
    TabInfo(1, '我的关注'),
    TabInfo(2, '观看记录'),
    TabInfo(3, '我的徽章')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: Tools.getStatusHeight(context) + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[_renderTop(), _renderHeader(), _renderList()],
        ),
      ),
    );
  }

  GestureDetector _renderTop() {
    return GestureDetector(
      onTap: () {
        //todo
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.only(right: 15, top: 5),
        child: Icon(Icons.more_horiz, color: Colors.black54, size: 15),
      ),
    );
  }

  Container _renderHeader() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      decoration: ActionViewUtils.renderBorderBottom(),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400], width: 2),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: new ClipOval(
              child: Image.network(
                'http://img.kaiyanapp.com/63006ecab0eebd80d61a3dceacc5749c.jpeg',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '188****9350',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                Map<String, String> params = new Map();
                params['id'] = Constants.uid;
                params['userType'] = 'NORMAL';
                return StickyHeaderTabPage(url: API.USER_TABS, params: params);
              }));
            },
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text('查看个人主页',
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ),
                    Image.asset('asset/images/arrow_right.png',
                        width: 10, height: 10)
                  ],
                )),
          ),
          _renderActionTools()
        ],
      ),
    );
  }

  Row _renderActionTools() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return CollectionPage(DBSource.collection, title: '我的喜欢');
            }));
          },
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    '喜欢',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: 20,
          width: 1,
          color: Colors.grey[300],
        ),
        ShareBtnWidget(showRightText: true, actionType: ShareType.goToCache),
      ],
    );
  }

  _renderList() {
    return Expanded(
        child: CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        new SliverList(
          delegate: new SliverChildListDelegate(
            _itemList.map((item) {
              return GestureDetector(
                onTap: () {
                  switch (item.id) {
                    case 1:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        Map<String, String> params = Map();
                        params['uid'] = Constants.uid;
                        return CommonTabListPage(API.MY_FOLLOW,
                            title: item.name, params: params);
                      }));
                      break;
                    case 2:
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CollectionPage(DBSource.watch, title: '观看记录');
                      }));
                      break;
                    case 3:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        Map<String, String> params = Map();
                        params['uid'] = Constants.uid;
                        return CommonListPage(API.MY_MEDALS,
                            title: item.name, params: params);
                      }));
                      break;
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    item.name,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ));
  }
}
