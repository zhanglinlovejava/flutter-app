import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class DailyPage extends StatefulWidget {
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
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
                  return FollowCardWidget(
                      cover: data['content']['data']['cover']['feed'],
                      avatar: data['header']['icon'],
                      title: data['header']['title'],
                      heroTag: data['content']['data']['id'],
                      desc: data['header']['description'],
                      duration: data['content']['data']['duration'],
                      onCoverTap: () {
                        ActionViewUtils.actionVideoPlayPage(
                            context, data['content']['data']);
                      });
                } else {
                  return new Container();
                }
              }),
        ));
  }

  _fetchFeedList() async {
    await HttpController.getInstance().get('v5/index/tab/feed', ((data) {
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
