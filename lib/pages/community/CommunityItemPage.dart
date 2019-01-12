import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/widgets/LoadEmptyWidget.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
import 'package:flutter_open/component/widgets/SquareCardCollectionWidget.dart';
import 'package:flutter_open/component/widgets/AutoPlayFollowCardWidget.dart';
import 'package:flutter_open/component/widgets/HorizontalScrollCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/widgets/VideoCollectionWithBriefWidget.dart';
import 'package:flutter_open/component/widgets/BriefCardWidget.dart';
import 'package:flutter_open/component/widgets/DynamicInfoCardWidget.dart';

class CommunityItemPage extends StatefulWidget {
  final String url;

  CommunityItemPage(this.url);

  _CommunityItemPageState createState() => _CommunityItemPageState();
}

class _CommunityItemPageState extends BaseAliveSate<CommunityItemPage> {
  List _itemList = [];
  LoadingStatus _status = LoadingStatus.loading;
  String _errMsg;

  @override
  void initState() {
    super.initState();
    _fetchCommunityList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: new LoadingView(
          status: _status,
          loadingContent: const PlatformAdaptiveProgressIndicator(),
          emptyContent: LoadEmptyWidget(onRetryFunc: () {
            setState(() {
              _status = LoadingStatus.loading;
            });
            _fetchCommunityList();
          }),
          errorContent: _renderErrorOrEmpty(),
          successContent: new ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                String type = _itemList[index]['type'];
                var data = _itemList[index]['data'];

                if (type == 'squareCardCollection') {
                  return SquareCardCollectionWidget(
                    data,
                    height: 220,
                  );
                } else if (type == 'videoCollectionOfHorizontalScrollCard') {
                  return SquareCardCollectionWidget(
                    data,
                    height: 280,
                  );
                }
                if (type == 'pictureFollowCard') {
                  return AutoPlayFollowCardWidget(data);
                } else if (type == 'videoSmallCard') {
                  return VideoSmallCardWidget(
                    id: data['id'],
                    cover: data['cover']['feed'],
                    title: data['title'],
                    duration: data['duration'],
                    category: data['category'],
                    onCoverTap: () {
                      ActionViewUtils.actionVideoPlayPage(context,
                          desc: data['description'],
                          id: data['id'],
                          category: data['category'],
                          author: data['author'],
                          cover: data['cover'],
                          consumption: data['consumption'],
                          title: data['title']);
                    },
                  );
                }
                if (type == 'autoPlayFollowCard') {
                  return AutoPlayFollowCardWidget(data);
                } else if (type == 'horizontalScrollCard') {
                  return HorizontalScrollCardWidget(itemList: data['itemList']);
                } else if (type == 'textCard') {
                  return TextCardWidget(data);
                } else if (type == 'videoCollectionWithBrief') {
                  return VideoCollectionWithBriefWidget(data);
                } else if (type == 'briefCard') {
                  return BriefCardWidget(
                      icon: data['icon'], title: data['title']);
                } else if (type == 'DynamicInfoCard') {
                  return DynamicInfoCardWidget(data);
                } else {
                  return new Text(
                    type,
                    style: TextStyle(color: Colors.green),
                  );
                }
              }),
        ));
  }

  _renderErrorOrEmpty() {
    return LoadErrorWidget(
        onRetryFunc: () {
          setState(() {
            _status = LoadingStatus.loading;
          });
          _fetchCommunityList();
        },
        errMsg: _errMsg ?? '出错了');
  }

  _fetchCommunityList() {
    HttpController.getInstance().get(widget.url, (data) {
      print(widget.url);
      _itemList = data['itemList'];
      _status =
          _itemList.length == 0 ? LoadingStatus.empty : LoadingStatus.success;
      if (mounted) {
        setState(() {});
      }
    }, errorCallback: (error) {
      if (mounted) {
        setState(() {
          _status = LoadingStatus.error;
          _errMsg = '加载失败了，请稍后重试~';
        });
      }
    });
  }
}
