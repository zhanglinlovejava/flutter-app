import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/widgets/AutoPlayFollowCardWidget.dart';

class FollowPage extends StatefulWidget {
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  List _itemList = [];
  LoadingStatus _status = LoadingStatus.loading;
  String _errMsg;

  @override
  void initState() {
    super.initState();
    _fetchFollowList();
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
                _fetchFollowList();
              },
              errMsg: _errMsg ?? '出错了'),
          successContent: new ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                String type = _itemList[index]['type'];
                var data = _itemList[index]['data'];
                if (type == 'autoPlayFollowCard') {
                  return AutoPlayFollowCardWidget(data);
                } else {
                  return new Text(type);
                }
              }),
        ));
  }

  _fetchFollowList() {
    HttpController.getInstance().get('v6/community/tab/follow', (data) {
      List list = data['itemList'];
      _itemList = list;
      _status = LoadingStatus.success;
      if (mounted) {
        setState(() {});
      }
    }, errorCallback: (error) {
      if (mounted) {
        setState(() {
          _status = LoadingStatus.error;
          _errMsg = error.toString();
        });
      }
    });
  }
}
