import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/pages/community/CommunityItemPage.dart';
import 'package:flutter_open/component/widgets/FollowBtnWidget.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'package:flutter_open/api/API.dart';

const double tabBarHeight = 40;
const double expandedHeight = 334;

class UserInfoPage extends StatefulWidget {
  final String id;
  final String userType;

  UserInfoPage({this.id, this.userType});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  LoadingStatus _status = LoadingStatus.loading;
  ScrollController scrollController = ScrollController();
  double scrollMaxHeight = 0;
  double opacity = 0;
  Color titleColor = Colors.white;
  TabList tabList;
  var _userInfo;
  String _errMsg = '加载出错了，请稍后重试~';

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      opacity = scrollController.offset / scrollMaxHeight;
      titleColor = opacity > 0.6 ? titleColor = Colors.black : Colors.white;
      setState(() {});
    });
    _fetchTabList();
  }

  @override
  Widget build(BuildContext context) {
    scrollMaxHeight = expandedHeight - kToolbarHeight - tabBarHeight;
    return new Container(
      color: Colors.white,
      child: LoadingView(
          status: _status,
          loadingContent: PlatformAdaptiveProgressIndicator(),
          errorContent: LoadErrorWidget(
              errMsg: _errMsg,
              onRetryFunc: () {
                _fetchTabList();
              }),
          successContent: tabList == null ||
                  tabList.tabList == null ||
                  tabList.tabList.length == 0
              ? new Container()
              : DefaultTabController(
                  length: tabList.tabList.length,
                  child: new Scaffold(
                    body: new NestedScrollView(
                        controller: scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return _renderSliverBuilder(
                              context, innerBoxIsScrolled);
                        },
                        body: _renderTabBarView()),
                  ))),
    );
  }

  List<Widget> _renderSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      new SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        child: new SliverAppBar(
          titleSpacing: 0,
          title: Text(
            _userInfo['name'],
            style: TextStyle(
                fontFamily: 'FZLanTing',
                color: Color.fromRGBO(0, 0, 0, opacity),
                fontSize: 16),
            textAlign: TextAlign.left,
          ),
          leading: new Container(
            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: titleColor,
            ),
          ),
          pinned: true,
          expandedHeight: expandedHeight,
          forceElevated: innerBoxIsScrolled,
          bottom: PreferredSize(
              child: renderTabBar(),
              preferredSize: new Size(double.infinity, tabBarHeight)),
          flexibleSpace: renderHeaderView(),
        ),
      )
    ];
  }

  renderHeaderView() {
    return new Container(
      color: Colors.white,
      foregroundDecoration:
          BoxDecoration(color: Color.fromRGBO(255, 255, 255, opacity)),
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _renderBg(),
              _renderAuthorInfo(),
              _renderFollowerLayout()
            ],
          ),
          Positioned(
            top: 132,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  border: Border.all(color: Colors.white, width: 2)),
              child: ClipOval(
                child: Image.network(
                  _userInfo['icon'],
                  width: 66,
                  height: 66,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _renderFollowerLayout() {
    return Container(
      height: 80,
      padding: EdgeInsets.all(15),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderFollowItem(_userInfo['videoCount'], '作品'),
          _renderFollowItem(_userInfo['collectCount'], '关注'),
          _renderFollowItem(_userInfo['myFollowCount'], '粉丝'),
        ],
      ),
    );
  }

  _renderFollowItem(int count, String label) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 17, color: Colors.black, fontFamily: 'FZLanTing')),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey))
        ],
      ),
    );
  }

  _renderBg() {
    return Container(
      height: 190,
      child: Stack(
        children: <Widget>[
          Image.network(
            _userInfo['cover'] ??
                'http://img.kaiyanapp.com/0f69c8a80fe3c600a7eec35c69a7e9fc.jpeg?imageMogr2/quality/60/format/jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
          ),
          Positioned(
              right: 10,
              bottom: 12,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 90,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        color: Color(0xffeeeeee),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    padding:
                        EdgeInsets.only(left: 10, right: 8, top: 3, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          '主题徽章',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'FZLanTing'),
                        )),
                        Text(
                          _userInfo['medalsNum'].toString(),
                          style:
                              TextStyle(fontSize: 10, fontFamily: 'FZLanTing'),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
              right: 85,
              bottom: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.star,
                  color: Colors.black,
                  size: 15,
                ),
              ))
        ],
      ),
    );
  }

  _renderAuthorInfo() {
    return Container(
      height: 64,
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _userInfo['name'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'FZLanTing'),
                        ),
                        Text(
                          _userInfo['brief'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )),
                  FollowBtnWidget(isDark: true)
                ],
              ))
        ],
      ),
    );
  }

  renderTabBar() {
    return new Container(
        color: Colors.white,
        height: tabBarHeight,
        child: new TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.black,
            indicatorColor: Color(0xff000001),
            tabs: tabList.tabList
                .map((tabInfo) => Tab(text: tabInfo.name))
                .toList()));
  }

  _renderTabBarView() {
    return new Container(
        padding: EdgeInsets.only(top: 110),
        child: new TabBarView(
            children: tabList.tabList
                .map((tabInfo) => CommunityItemPage(tabInfo.apiUrl))
                .toList()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  _fetchTabList() async {
    Map<String, String> params = new Map();
    params['id'] = widget.id;
    params['userType'] = widget.userType.toUpperCase();
    await HttpController.getInstance().get(API.USER_TABS, (data) {
      var tabInfo = data['tabInfo'];
      if (widget.userType == 'PGC') {
        _userInfo = data['pgcInfo'];
      } else if (widget.userType == 'NORMAL') {
        _userInfo = data['userInfo'];
      }
      if (tabInfo == null || tabInfo['tabList'] == null) {
        _status = LoadingStatus.error;
        _errMsg = data['errorMessage'];
      } else {
        tabList = TabList.map(tabInfo['tabList']);
        _status = LoadingStatus.success;
      }
      if (mounted) setState(() {});
    }, errorCallback: (error) {
      _status = LoadingStatus.success;
      if (mounted) setState(() {});
    }, params: params);
  }
}
