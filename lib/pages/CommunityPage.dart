import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/pages/CommonListPage.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'package:flutter_open/entity/TabInfo.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/api/API.dart';
import 'SearchPage.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() {
    return _CommunityPageState();
  }
}

class _CommunityPageState extends BaseAliveSate<CommunityPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  LoadingStatus _status = LoadingStatus.loading;
  List<Widget> tabs = new List();
  TabList tabList;
  List<Widget> pagesList = new List();
  int currentIndex = 0;
  VoidCallback tabListener;

  @override
  void initState() {
    super.initState();
    tabListener = () {
      currentIndex = _tabController.index;
      tabs.clear();
      for (var i = 0; i < tabList.tabList.length - 1; i++) {
        tabs.add(_renderTab(tabList.tabList[i], i == currentIndex));
      }
      setState(() {
        tabs = tabs;
      });
    };
    _fetchTabList();
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingView(
        status: _status,
        loadingContent: const PlatformAdaptiveProgressIndicator(strokeWidth: 2),
        errorContent: LoadErrorWidget(onRetryFunc: () {
          _fetchTabList();
        }),
        successContent: _tabController == null
            ? new Container()
            : new Container(
                margin: EdgeInsets.only(top: 20),
                child: new Column(
                  children: <Widget>[
                    _renderAppBar(),
                    _buildTabBar(),
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: pagesList,
                    ))
                  ],
                )));
  }

  _renderAppBar() {
    return new Container(
      height: 35,
      padding: EdgeInsets.only(top: 10),
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            child: Text('subscription',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Lobster', fontSize: 20)),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return SearchPage();
                  }));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.search,
                    size: 27,
                  ),
                )),
          )
        ],
      ),
    );
  }

  _buildTabBar() {
    return new Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: _tabController == null
          ? new Container()
          : new Container(
              width: double.infinity,
              height: 50,
              child: TabBar(
                  labelStyle: TextStyle(fontFamily: 'FZLanTing'),
                  tabs: tabs,
                  labelPadding: EdgeInsets.only(right: 5),
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  controller: _tabController)),
    );
  }

  _renderTab(TabInfo tabInfo, bool isSelected) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color.fromRGBO(0, 0, 0, isSelected ? 0.01 : 0.5),
          ),
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            child: Image.network(
              tabInfo.bgPicture,
              width: 110,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          tabInfo.name,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
        )
      ],
    );
  }

  _fetchTabList() async {
    HttpController.getInstance().get(API.COMMUNITY_TAB, (data) {
      tabList = TabList.map(data['tabInfo']['tabList']);
      initTabView();
    }, errorCallback: (error) {
      if (mounted) {
        setState(() {
          _status = LoadingStatus.error;
        });
      }
    });
  }

  void initTabView() {
    for (var i = 0; i < tabList.tabList.length - 1; i++) {
      tabs.add(_renderTab(tabList.tabList[i], i == currentIndex));
      pagesList.add(CommonListPage(tabList.tabList[i].apiUrl));
    }
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.removeListener(tabListener);
    _tabController.addListener(tabListener);
    _status = LoadingStatus.success;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) _tabController.dispose();
  }
}
