import 'package:flutter/material.dart';
import '../api/API.dart';
import '../api/HttpController.dart';
import '../component/loading/LoadingStatus.dart';
import '../component/loading/loading_view.dart';
import '../component/loading/platform_adaptive_progress_indicator.dart';
import '../component/widgets/LoadErrorWidget.dart';
import '../component/widgets/LoadEmptyWidget.dart';
import '../pages/CommonListPage.dart';
import '../utils/ActionViewUtils.dart';
import '../Constants.dart';

class CommonTabListPage extends StatefulWidget {
  final String tabListUrl;
  final String title;
  final String type;
  final Map<String,String> params;
  CommonTabListPage(this.tabListUrl, {this.title, this.type = 'common',this.params});

  @override
  _CommonTabListPageState createState() => _CommonTabListPageState();
}

class _CommonTabListPageState extends State<CommonTabListPage>
    with SingleTickerProviderStateMixin {
  LoadingStatus _status = LoadingStatus.loading;
  TabController _tabController;
  List _tabList = [];

  @override
  void initState() {
    super.initState();
    _fetchRankList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ActionViewUtils.buildAppBar(
            title: widget.title,
            titleStyle: TextStyle(fontFamily: ConsFonts.lobFont),
            elevation: 0),
        body: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: LoadingView(
              status: _status,
              loadingContent: PlatformAdaptiveProgressIndicator(strokeWidth: 2),
              errorContent: LoadErrorWidget(onRetryFunc: () {
                _status = LoadingStatus.loading;
                _fetchRankList();
              }),
              emptyContent: LoadEmptyWidget(onRetryFunc: () {
                _status = LoadingStatus.loading;
                _fetchRankList();
              }),
              successContent: Container(
                child: Column(
                    children: <Widget>[_renderTabBar(), _renderContentViews()]),
              )),
        ));
  }

  _renderContentViews() {
    return Expanded(
        child: TabBarView(
            controller: _tabController,
            children: _tabList.map((tab) {
              return CommonListPage(tab['apiUrl'], type: widget.type);
            }).toList()));
  }

  _renderTabBar() {
    return Container(
      height: 40,
      decoration: ActionViewUtils.renderBorderBottom(),
      padding: EdgeInsets.only(bottom: 5),
      child: TabBar(
          labelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontFamily: ConsFonts.fzFont),
          tabs: _tabList.map((tab) {
            return Tab(text: tab['name']);
          }).toList()),
    );
  }

  _fetchRankList() async {
    await HttpController.getInstance().get(widget.tabListUrl, (data) {
      if (data != null && data['tabInfo'] != null) {
        _tabList = data['tabInfo']['tabList'] ?? [];
        _status =
            _tabList.length > 0 ? LoadingStatus.success : LoadingStatus.empty;
        _tabController = TabController(length: _tabList.length, vsync: this);
        if (mounted) {
          setState(() {});
        }
      }
    }, errorCallback: (_) {
      _status = LoadingStatus.error;
      if (mounted) {
        setState(() {});
      }
    },params: widget.params);
  }
}
