import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/pages/home/CategoryPage.dart';
import 'package:flutter_open/pages/home/DiscoveryPage.dart';
import 'package:flutter_open/pages/home/RecommendPage.dart';
import 'package:flutter_open/pages/home/DailyPage.dart';
import 'package:flutter_open/pages/home/FollowPage.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'package:flutter_open/db/DBManager.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/api/API.dart';

class HomePage extends StatefulWidget {
  final TabList homeTabList;

  HomePage(this.homeTabList);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends BaseAliveSate<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = <Tab>[];
  List<int> ids = [];
  LoadingStatus _status = LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    _getTabListIfNeed();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        child: new LoadingView(
          status: _status,
          loadingContent: const PlatformAdaptiveProgressIndicator(),
          errorContent: LoadErrorWidget(onRetryFunc: () {
            _fetchTabList();
          }),
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
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: Colors.grey[200], width: 1))),
      padding: EdgeInsets.only(left: 5, right: 5, top: 5,bottom: 3),
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
                      height: 30,
                      child: TabBar(
                          labelStyle:
                              TextStyle(fontFamily: 'FZLanTing', fontSize: 13),
                          tabs: tabs,
                          labelPadding: EdgeInsets.only(left: 15, right: 15),
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
      } else if (id == -5) {
        list.add(FollowPage());
      }
    });
    return list;
  }

  _getTabListIfNeed() async {
    var dbClient = DBManager();
    TabList tabList;
    if (widget.homeTabList != null &&
        widget.homeTabList.tabList != null &&
        widget.homeTabList.tabList.length > 0) {
      tabList = widget.homeTabList;
      initTabBar(tabList);
    } else {
      tabList = await dbClient.queryHomeTabList();
      if (tabList.tabList.length == 0) {
        tabs.insert(
            0,
            Tab(
              text: "关注",
              key: Key('-5'),
            ));
        _fetchTabList();
      } else {
        initTabBar(tabList);
      }
    }
  }

  _fetchTabList() async {
    await HttpController.getInstance().get(API.HOME_TAB, (data) {
      TabList tabList = TabList.map(data['tabInfo']['tabList']);
      DBManager().saveHomeTabList(tabList);
      initTabBar(tabList);
    }, errorCallback: (error) {});
  }

  void initTabBar(TabList tabList) {
    tabList.tabList.forEach((it) {
      tabs.add(Tab(
        text: it.name,
        key: Key(it.id.toString()),
      ));
    });
    _tabController = new TabController(vsync: this, length: tabs.length);
    _tabController.animateTo(2);
    setState(() {
      _status = LoadingStatus.success;
    });
  }
}
