import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/pages/home/CategoryPage.dart';
import 'package:flutter_open/pages/home/DiscoveryPage.dart';
import 'package:flutter_open/pages/home/RecommendPage.dart';
import 'package:flutter_open/pages/home/DailyPage.dart';
import 'package:flutter_open/pages/home/AreaPage.dart';
import 'package:flutter_open/pages/home/FollowPage.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = <Tab>[];
  List<int> ids = [];
  LoadingStatus _status = LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    _fetchTabList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: new LoadingView(
          status: _status,
          loadingContent: const PlatformAdaptiveProgressIndicator(),
          errorContent: new GestureDetector(
            onTap: () {
              _fetchTabList();
            },
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                Text(
                  "出错了",
                  style: new TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          successContent: new Column(
            children: <Widget>[
              _buildTabBar(),
              _tabController == null
                  ? new Container(
                      width: MediaQuery.of(context).size.width - 100,
                      color: Colors.transparent,
                    )
                  : Expanded(
                      child: TabBarView(
                      controller: _tabController,
                      children: _buildTabPage(),
                    ))
            ],
          ),
        ));
  }

  _buildTabBar() {
    return new Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Container(
            width: 35,
            child: new Icon(
              Icons.menu,
              size: 20,
              color: Colors.black,
            ),
          ),
          _tabController == null
              ? new Container()
              : Expanded(
                  child: new Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      height: 36.0,
                      child: TabBar(
                          labelStyle: TextStyle(fontFamily: 'FZLanTing'),
                          tabs: tabs,
                          isScrollable: true,
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: Colors.grey[400],
                          controller: _tabController)),
                ),
          new Container(
            width: 35,
            child: new Icon(
              Icons.search,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabPage() {
    List<Widget> list = [];
    tabs.forEach((tab) {
      List<String> strings = tab.key.toString().split("'");
      int id = int.parse(strings[1]);
      if (id > 0) {
        list.add(new CategoryPage(
          categoryId: id,
        ));
      } else if (id == -1) {
        list.add(DiscoveryPage());
      } else if (id == -2) {
        list.add(RecommendPage());
      } else if (id == -3) {
        list.add(DailyPage());
      } else if (id == -4) {
        list.add(AreaPage());
      } else if (id == -5) {
        list.add(FollowPage());
      }
    });
    return list;
  }

  _fetchTabList() async {
    await HttpController.getInstance().get('v5/index/tab/list', (data) {
      List tabList = data['tabInfo']['tabList'];
      tabList.forEach((it) {
        tabs.add(Tab(
          text: it['name'],
          key: Key(it['id'].toString()),
        ));
      });
      tabs.insert(
          0,
          Tab(
            text: "关注",
            key: Key('-5'),
          ));
      _tabController = new TabController(vsync: this, length: tabs.length);
      _tabController.animateTo(2);
      setState(() {
        _status = LoadingStatus.success;
      });
    }, errorCallback: (error) {});
  }
}
