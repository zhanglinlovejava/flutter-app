import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/pages/CommonListPage.dart';
import 'package:flutter_open/component/widgets/FollowBtnWidget.dart';
import 'package:flutter_open/entity/TabList.dart';
import 'dart:io';
import '../component/widgets/FollowBtnWidget.dart';
import '../Constants.dart';

const double tabBarHeight = 40;
double userInfoHeight = Platform.isIOS ? 356 : 336;
double tagInfoHeight = Platform.isIOS ? 240 : 220;

class StickyHeaderTabPage extends StatefulWidget {
  final Map<String, String> params;
  final String url;
  final String type;

  StickyHeaderTabPage(
      {@required this.url, @required this.params, this.type = 'userInfo'});

  @override
  _StickyHeaderTabPageState createState() => _StickyHeaderTabPageState();
}

class _StickyHeaderTabPageState extends State<StickyHeaderTabPage>
    with SingleTickerProviderStateMixin {
  double _expandedHeight;
  LoadingStatus _status = LoadingStatus.loading;
  ScrollController _scrollController = ScrollController();
  double _scrollMaxHeight = 0;
  double _opacity = 0;
  Color _titleColor = Colors.white;
  TabList _tabList;
  String _type;
  var _userInfo;

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    _expandedHeight = _type == 'userInfo' ? userInfoHeight : tagInfoHeight;
    _scrollController.addListener(() {
      _opacity = _scrollController.offset / _scrollMaxHeight;
      _titleColor = _opacity > 0.6 ? _titleColor = Colors.black : Colors.white;
      setState(() {});
    });
    _fetchTabList();
  }

  @override
  Widget build(BuildContext context) {
    _scrollMaxHeight = _expandedHeight - kToolbarHeight - tabBarHeight;
    return new Container(
      color: Colors.white,
      child: LoadingView(
          status: _status,
          loadingContent: PlatformAdaptiveProgressIndicator(strokeWidth: 2),
          errorContent: LoadErrorWidget(onRetryFunc: () {
            _fetchTabList();
          }),
          successContent: _tabList == null ||
                  _tabList.tabList == null ||
                  _tabList.tabList.length == 0
              ? new Container()
              : DefaultTabController(
                  length: _tabList.tabList.length,
                  child: new Scaffold(
                    body: new NestedScrollView(
                        controller: _scrollController,
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
                fontFamily: ConsFonts.fzFont,
                color: Color.fromRGBO(0, 0, 0, _opacity),
                fontSize: 16),
            textAlign: TextAlign.left,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: new Container(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: _titleColor,
              ),
            ),
          ),
          pinned: true,
          expandedHeight: _expandedHeight,
          forceElevated: innerBoxIsScrolled,
          bottom: PreferredSize(
              child: renderTabBar(),
              preferredSize: new Size(double.infinity, tabBarHeight)),
          flexibleSpace: _renderHeader(),
        ),
      )
    ];
  }

  _renderTagInfoHeader() {
    return Container(
      height: _expandedHeight,
      child: Stack(
        alignment: AlignmentDirectional(0, 0.5),
        children: <Widget>[
          Container(
            foregroundDecoration:
                BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
            child: Image.network(
              _userInfo['headerImage'] ?? _userInfo['bgPicture'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
              top: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 50, right: 50),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      _userInfo['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: ConsFonts.fzFont),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      child: Text(_userInfo['description'] ?? ' ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xffdddddd), fontSize: 14))),
                  _type == 'tagInfo'
                      ? Row(
                          children: <Widget>[
                            Text('${_userInfo['tagFollowCount']}人关注',
                                style: TextStyle(
                                    color: Color(0xffdddddd), fontSize: 12)),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                color: Color(0xffdddddd),
                                height: 10,
                                width: 1),
                            Text('${_userInfo['lookCount']}人看过',
                                style: TextStyle(
                                    color: Color(0xffdddddd), fontSize: 12)),
                          ],
                        )
                      : Container(),
                  _type == 'tagInfo'
                      ? Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: FollowBtnWidget())
                      : Container()
                ],
              )),
        ],
      ),
    );
  }

  _renderHeader() {
    return new Container(
      color: Colors.white,
      foregroundDecoration:
          BoxDecoration(color: Color.fromRGBO(255, 255, 255, _opacity)),
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          _type == 'userInfo' ? _renderUserHeader() : _renderTagInfoHeader(),
          _type == 'userInfo'
              ? Positioned(
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
              : Container()
        ],
      ),
    );
  }

  Column _renderUserHeader() {
    return Column(
      children: <Widget>[
        _renderBg(),
        _renderAuthorInfo(),
        _renderFollowerLayout()
      ],
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
                  fontSize: 17,
                  color: Colors.black,
                  fontFamily: ConsFonts.fzFont)),
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
            _userInfo['cover'] ?? 'http://',
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
                          style: TextStyle(
                              fontSize: 12, fontFamily: ConsFonts.fzFont),
                        )),
                        Text(
                          _userInfo['medalsNum'].toString(),
                          style: TextStyle(
                              fontSize: 10, fontFamily: ConsFonts.fzFont),
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
      height: 66,
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
                              fontFamily: ConsFonts.fzFont),
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
            tabs: _tabList.tabList
                .map((tabInfo) => Tab(text: tabInfo.name))
                .toList()));
  }

  _renderTabBarView() {
    return new Container(
        padding: EdgeInsets.only(top: 110),
        child: new TabBarView(
            children: _tabList.tabList
                .map((tabInfo) =>
                    CommonListPage(tabInfo.apiUrl, userLoadMore: false))
                .toList()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _fetchTabList() async {
    await HttpController.getInstance().get(widget.url, (data) {
      var tabInfo = data['tabInfo'];
      _userInfo = data['pgcInfo'] == null ? data[_type] : data['pgcInfo'];
      if (tabInfo == null || tabInfo['tabList'] == null || _userInfo == null) {
        _status = LoadingStatus.error;
      } else {
        _tabList = TabList.map(tabInfo['tabList']);
        _status = LoadingStatus.success;
      }
      if (mounted) setState(() {});
    }, errorCallback: (error) {
      _status = LoadingStatus.success;
      if (mounted) setState(() {});
    }, params: widget.params);
  }
}
