import 'package:flutter/material.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/widgets/LoadEmptyWidget.dart';

abstract class BaseLoadListSate<T extends StatefulWidget>
    extends BaseAliveSate<T> {
  List<dynamic> itemList = new List();
  LoadingStatus status = LoadingStatus.loading;
  bool hasNoMoreData = false;
  ScrollController scrollController = ScrollController();
  int start = 0;
  int num = 20;

  String url();

  String getType();

  renderItemRow(BuildContext context, int index);

  Map<String, String> getParams();

  bool registerScrollController();

  Widget getAppBar();

  initState() {
    super.initState();
    if (registerScrollController()) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          fetchList(isLoadMore: true);
        }
      });
    }
    fetchList();
  }

  build(BuildContext context) {
    var appBar = getAppBar();
    if (appBar == null) {
      return _renderContent();
    } else {
      return Scaffold(
        appBar: appBar,
        body: Center(child: _renderContent()),
      );
    }
  }

  Future _onRefresh() async {
    _retryFetch();
  }

  _renderContent() {
    return RefreshIndicator(
        child: new Container(
            height: double.infinity,
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: new LoadingView(
              status: status,
              loadingContent:
                  const PlatformAdaptiveProgressIndicator(strokeWidth: 2),
              emptyContent: LoadEmptyWidget(onRetryFunc: () {
                _retryFetch();
              }),
              errorContent: LoadErrorWidget(onRetryFunc: () {
                _retryFetch();
              }),
              successContent: registerScrollController()
                  ? new ListView.builder(
                      itemCount: itemList.length,
                      controller: scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return renderItemRow(context, index);
                      })
                  : new ListView.builder(
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return renderItemRow(context, index);
                      }),
            )),
        onRefresh: _onRefresh);
  }

  _retryFetch({bool showLoading = false}) {
    start = 0;
    if (showLoading) {
      status = LoadingStatus.loading;
      setState(() {});
    }

    fetchList(isRefresh: true);
  }

  fetchList({bool isLoadMore = false, isRefresh = false}) {
    if (hasNoMoreData) {
      return;
    }
    Map<String, String> params = getParams() ?? Map();
    params['start'] = start.toString();
    params['num'] = num.toString();
    HttpController.getInstance().get(url(), (data) {
      if (data != null) {
        List temList = [];
        if (getType() == 'common') {
          temList = data['itemList'] ?? [];
        } else if (getType() == 'message') {
          temList = data['messageList'] ?? [];
        }
        if (temList.length == 0) {
          if (mounted) {
            if (itemList.length > 0) {
              itemList.add(itemList[0]);
              hasNoMoreData = true;
            } else {
              status = LoadingStatus.empty;
            }
            setState(() {});
          }
          return;
        }
        start += num;
        if (isRefresh) itemList.clear();
        temList.forEach((item) {
          if (item != null) {
            itemList.add(item);
          }
        });
        if (!registerScrollController()) {
          itemList.add(itemList[0]);
        }
        status = LoadingStatus.success;
        if (mounted) {
          setState(() {});
        }
      }
    }, errorCallback: (error) {
      if (!isLoadMore) {
        if (mounted) {
          status = LoadingStatus.error;
          setState(() {});
        }
      }
    }, params: params);
  }
}
