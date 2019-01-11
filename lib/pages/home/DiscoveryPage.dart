import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardFoot2Widget.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/component/widgets/SquareCardCollectionWidget.dart';
import 'package:flutter_open/component/widgets/HorizontalScrollCardWidget.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/component/widgets/BriefCardWidget.dart';
import 'package:flutter_open/component/widgets/DynamicInfoCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/TheEndWidget.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/api/API.dart';
import 'package:flutter_open/component/widgets/VideoCollectionWithBriefWidget.dart';

class DiscoveryPage extends StatefulWidget {
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends BaseAliveSate<DiscoveryPage> {
  List _itemList = [];
  LoadingStatus _status = LoadingStatus.loading;
  String _errMsg;

  @override
  void initState() {
    super.initState();
    _fetchDiscoveryList();
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
                _fetchDiscoveryList();
              },
              errMsg: _errMsg ?? '出错了'),
          successContent: new ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                String type = _itemList[index]['type'];
                var data = _itemList[index]['data'];
                if (type == 'textCard') {
                  if (data['type'] == 'footer2') {
                    return TextCardFoot2Widget(title: data['text']);
                  } else {
                    return TextCardWidget(data);
                  }
                } else if (index == _itemList.length - 1) {
                  return TheEndWidget(
                    color: 0xff000000,
                  );
                } else if (type == 'briefCard') {
                  return BriefCardWidget(
                      icon: data['icon'], title: data['title']);
                } else if (type == 'videoSmallCard') {
                  return VideoSmallCardWidget(
                    id: data['id'],
                    cover: data['cover']['feed'],
                    title: data['title'],
                    duration: data['duration'],
                    category: data['category'],
                    onCoverTap: () {
                      ActionViewUtils.actionVideoPlayPage(context, data);
                    },
                  );
                } else if (type == 'followCard') {
                  return FollowCardWidget(
                    cover: data['content']['data']['cover']['feed'],
                    avatar: data['header']['icon'],
                    title: data['header']['title'],
                    heroTag: data['content']['data']['id'],
                    desc: data['header']['description'],
                    duration: data['content']['data']['duration'],
                    id: data['content']['data']['author']['id'].toString(),
                    userType: 'PGC',
                    onCoverTap: () {
                      ActionViewUtils.actionVideoPlayPage(
                          context, data['content']['data']);
                    },
                  );
                } else if (type == 'squareCardCollection') {
                  return SquareCardCollectionWidget(
                    data,
                    height: 190,
                  );
                } else if (type == 'horizontalScrollCard') {
                  return HorizontalScrollCardWidget(itemList: data['itemList']);
                } else if (type == 'videoCollectionWithBrief') {
                  return VideoCollectionWithBriefWidget(data);
                } else if (type == 'DynamicInfoCard') {
                  return DynamicInfoCardWidget(data);
                } else {
                  return new Text(type);
                }
              }),
        ));
  }

  _fetchDiscoveryList() {
    HttpController.getInstance().get(API.DISCOVERY_LIST, (data) {
      List list = data['itemList'];
      _itemList = list;
      _status = LoadingStatus.success;
      _itemList.add(_itemList[0]);
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
