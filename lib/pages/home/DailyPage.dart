import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/api/API.dart';

class DailyPage extends StatefulWidget {
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends BaseAliveSate<DailyPage> {
  List _itemList = [];
  LoadingStatus _status = LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    _fetchFeedList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: new LoadingView(
          status: _status,
          loadingContent: const PlatformAdaptiveProgressIndicator(),
          errorContent: LoadErrorWidget(
              onRetryFunc: () {
                _fetchFeedList();
              },
              errMsg: '出错了'),
          successContent: new ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                String type = _itemList[index]['type'];
                var data = _itemList[index]['data'];
                if (type == 'textCard') {
                  return TextCardWidget(data);
                } else if (type == 'followCard') {
                  return
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: FollowCardWidget(
                        cover: data['content']['data']['cover']['feed'],
                        avatar: data['header']['icon'],
                        title: data['header']['title'],
                        desc: data['header']['description'],
                        duration: data['content']['data']['duration'],
                        id: data['content']['data']['author']['id'].toString(),
                        userType: 'PGC',
                        onCoverTap: () {
                          ActionViewUtils.actionVideoPlayPage(
                              context, data['content']['data']);
                        }) ,)
                   ;
                } else {
                  return Text(type);
                }
              }),
        ));
  }

  _fetchFeedList() async {
    await HttpController.getInstance().get(API.DAILY_LIST, ((data) {
      List list = data['itemList'];
      list.removeAt(0);
      if (mounted) {
        setState(() {
          _itemList = list;
          _status = LoadingStatus.success;
        });
      }
    }), errorCallback: ((error) {
      if (mounted) {
        setState(() {
          _status = LoadingStatus.error;
        });
      }
    }));
  }
}
