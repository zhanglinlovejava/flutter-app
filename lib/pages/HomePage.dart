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
import '../event/EventUtils.dart';
import 'dart:async';
import '../event/Events.dart';

class HomePage extends StatefulWidget {
  final TabList tabList;
  final int index;
  final String type;

  HomePage(this.tabList, {this.index = 0, this.type = 'home'});

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
  TabList _tabList;
  String url = API.HOME_TAB;
  StreamSubscription<UpdateHomeTabEvent> _streamSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'home') {
      url = API.HOME_TAB;
      _streamSubscription =
          EventUtils.on<UpdateHomeTabEvent>((UpdateHomeTabEvent event) {
        _tabController.animateTo(event.index);
      });
    } else if (widget.type == 'community') {
      url = API.COMMUNITY_TAB;
    }
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
              _tabList != null && _tabList.tabList != null
                  ? Expanded(
                      child: TabBarView(
                      controller: _tabController,
                      children: _tabList.tabList.map((tab) {
                        return CommonListPage(tab.apiUrl,
                            userLoadMore: tab.id != -1);
                      }).toList(),
                    ))
                  : Container()
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
          _tabController == null
              ? new Container()
              : Expanded(
                  child: new Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 35),
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

  _getTabListIfNeed() async {
    if (widget.tabList != null &&
        widget.tabList.tabList != null &&
        widget.tabList.tabList.length > 0) {
      _tabList = widget.tabList;
      initTabBar();
    } else {
      _fetchTabList();
    }
  }

  _fetchTabList() async {
    await HttpController.getInstance().get(url, (data) {
      _tabList = TabList.map(data['tabInfo']['tabList']);
      initTabBar();
    }, errorCallback: (error) {});
  }

  void initTabBar() {
    _tabList.tabList.forEach((it) {
      _tabs.add(Tab(text: it.name));
    });
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _tabController.animateTo(widget.index);
    if (mounted)
      setState(() {
        _status = LoadingStatus.success;
      });
  }

  @override
  void dispose() {
    if (_streamSubscription != null) _streamSubscription.cancel();
    super.dispose();
  }
}
