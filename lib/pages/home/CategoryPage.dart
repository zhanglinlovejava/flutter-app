import 'package:flutter/material.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/BaseAliveState.dart';
class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
  final int categoryId;

  CategoryPage({@required this.categoryId});
}

class _CategoryPageState extends BaseAliveSate<CategoryPage> {
  List _itemList = [];
  LoadingStatus _status = LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    _fetCategoryList();
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
                _fetCategoryList();
              },
              errMsg: '出错了'),
          successContent: new ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (BuildContext context, int index) {
                String type = _itemList[index]['type'];
                var data = _itemList[index]['data'];
                if (type == 'textCard') {
                  return TextCardWidget(data);
                } else if (type == 'banner2') {
                  return SingleBannerWidget(data['image']);
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
                } else {
                  return new Text(type);
                }
              }),
        ));
  }

  _fetCategoryList() async {
    await HttpController.getInstance()
        .get('v5/index/tab/category/${widget.categoryId}', (data) {
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
