import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/component/widgets/SquareCardCollectionWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/api/API.dart';

class RecommendPage extends StatefulWidget {
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends BaseAliveSate<RecommendPage> {
  List _itemList = [];
  LoadingStatus _status = LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    _fetchRecommendList();
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
                _fetchRecommendList();
              },
              errMsg: '出错了'),
          successContent: new ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                String type = _itemList[index]['type'];
                var data = _itemList[index]['data'];
                if (type == 'textCard') {
                  return TextCardWidget(data);
                } else if (type == 'banner2' || type == 'banner') {
                  return new Container(
                    margin: EdgeInsets.only(top: 10),
                    child: SingleBannerWidget(data['image']),
                  );
                } else if (type == 'followCard') {
                  return FollowCardWidget(
                    cover: data['content']['data']['cover']['feed'],
                    avatar: data['header']['icon'],
                    title: data['header']['title'],
                    desc: data['header']['description'],
                    id: data['content']['data']['author']['id'].toString(),
                    userType: 'PGC',
                    duration: data['content']['data']['duration'],
                    onCoverTap: () {
                      ActionViewUtils.actionVideoPlayPage(
                          context, data['content']['data']);
                    },
                  );
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
                } else if (type == 'squareCardCollection') {
                  return SquareCardCollectionWidget(
                    data,
                    height: 295,
                  );
                } else {
                  return new Text(type);
                }
              }),
        ));
  }

  _fetchRecommendList() {
    HttpController.getInstance().get(API.RECOMMEND_LIST, (data) {
      List list = data['itemList'];
      if (mounted) {
        setState(() {
          _itemList = list;
          _status = LoadingStatus.success;
        });
      }
    }, errorCallback: (error) {
      if (mounted) {
        setState(() {
          _status = LoadingStatus.error;
        });
      }
    });
  }
}
