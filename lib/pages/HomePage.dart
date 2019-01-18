import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/pages/CommonListPage.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/api/API.dart';
import 'SearchPage.dart';
import '../utils/ActionViewUtils.dart';

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
  List<Tab> _tabs = <Tab>[];
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
          loadingContent:
              const PlatformAdaptiveProgressIndicator(strokeWidth: 2),
          errorContent: LoadErrorWidget(onRetryFunc: () {
            _fetchTabList();
          }),
          successContent: new Column(
            children: <Widget>[
              _buildTabBar(),
              Expanded(
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
      decoration: ActionViewUtils.renderBorderBottom(),
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
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
                          tabs: _tabs,
                          labelPadding: EdgeInsets.only(left: 15, right: 15),
                          isScrollable: true,
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: Colors.grey[400],
                          controller: _tabController)),
                ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return SearchPage();
              }));
            },
            child: new Container(
              width: 35,
              child: new Icon(
                Icons.search,
                color: Colors.black,
                size: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabPage() {
    List<Widget> list = [];
    _tabs.forEach((tab) {
      List<String> strings = tab.key.toString().split("'");
      int id = int.parse(strings[1]);
      if (id > 0) {
        list.add(CommonListPage('${API.CATEGORY_LIST}/$id'));
      } else if (id == -1) {
        list.add(CommonListPage(API.DISCOVERY_LIST, userLoadMore: false));
      } else if (id == -2) {
        list.add(CommonListPage(API.RECOMMEND_LIST, changeTab: _scrollToTap));
      } else if (id == -3) {
        list.add(CommonListPage(API.DAILY_LIST));
      } else if (id == -5) {
        list.add(CommonListPage(API.FOLLOW_LIST));
      }
    });
    return list;
  }

  _getTabListIfNeed() async {
    TabList tabList;
    if (widget.homeTabList != null &&
        widget.homeTabList.tabList != null &&
        widget.homeTabList.tabList.length > 0) {
      tabList = widget.homeTabList;
      initTabBar(tabList);
    } else {
      _fetchTabList();
    }
  }

  _fetchTabList() async {
    await HttpController.getInstance().get(API.HOME_TAB, (data) {
      TabList tabList = TabList.map(data['tabInfo']['tabList']);
      initTabBar(tabList);
    }, errorCallback: (error) {});
  }

  void initTabBar(TabList tabList) {
    tabList.tabList.forEach((it) {
      _tabs.add(Tab(
        text: it.name,
        key: Key(it.id.toString()),
      ));
    });
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _tabController.animateTo(2);
    if (mounted)
      setState(() {
        _status = LoadingStatus.success;
      });
  }

  _scrollToTap(int index) {
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
