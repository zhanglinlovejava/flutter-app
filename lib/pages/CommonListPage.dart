import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/SquareCardCollectionWidget.dart';
import 'package:flutter_open/component/widgets/AutoPlayFollowCardWidget.dart';
import 'package:flutter_open/component/widgets/HorizontalScrollCardWidget.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/widgets/VideoCollectionWithBriefWidget.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/component/widgets/dynamicInfo/DynamicInfoCardWidget.dart';
import 'package:flutter_open/pages/BaseLoadListSate.dart';
import 'package:flutter_open/component/widgets/TheEndWidget.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';
import 'package:flutter_open/component/widgets/MessageItemWidget.dart';
import 'package:flutter_open/api/API.dart';
import '../component/widgets/BriefCardWidget.dart';

class CommonListPage extends StatefulWidget {
  final String url;
  final bool userLoadMore;
  final Map<String, String> params;
  final String type;
  final String title;
  final Function changeTab;

  CommonListPage(this.url,
      {this.userLoadMore = true,
      this.params,
      this.type = 'common',
      this.title = '',
      this.changeTab});

  _CommonListPageState createState() => _CommonListPageState();
}

class _CommonListPageState extends BaseLoadListSate<CommonListPage> {
  _renderItemRow(int index, BuildContext context) {
    if (widget.type == 'common') {
      return Container(
        child: _renderCommonItem(index, context),
      );
    } else if (widget.type == 'message') {
      return MEssageItemWidget(itemList[index]);
    }
  }

  _renderCommonItem(int index, BuildContext context) {
    String type = itemList[index]['type'];
    var data = itemList[index]['data'];
    if ((hasNoMoreData || !widget.userLoadMore) &&
        index == itemList.length - 1) {
      return TheEndWidget(color: 0xff000000);
    } else if (type == 'banner2' || type == 'banner' || type == 'banner3') {
      return new Container(
          margin: EdgeInsets.only(top: 10), child: SingleBannerWidget(data));
    } else if (type == 'squareCardCollection' ||
        type == 'videoCollectionOfHorizontalScrollCard') {
      return SquareCardCollectionWidget(data, onRightTap: () {
        String actionUrl = data['header']['actionUrl'];
        if (actionUrl.startsWith('eyepetizer://homepage/selected')) {
          if (widget.changeTab != null) widget.changeTab(3);
        } else if (actionUrl.startsWith('eyepetizer://categories/all')) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return CommonListPage(API.CATEGORY_ALL,
                title: '全部分类', userLoadMore: false);
          }));
        }
      });
    } else if (type == 'squareCard' || type == 'rectangleCard') {
      return _renderBriefCard(data, context);
    } else if (type == 'followCard') {
      return _renderFollowCard(data, context);
    } else if (type == 'pictureFollowCard') {
      return AutoPlayFollowCardWidget(data);
    } else if (type == 'videoSmallCard') {
      return _renderVideoSmallCard(data, context);
    } else if (type == 'autoPlayFollowCard') {
      return AutoPlayFollowCardWidget(data);
    } else if (type == 'horizontalScrollCard') {
      return HorizontalScrollCardWidget(itemList: data['itemList']);
    } else if (type == 'textCard') {
      return _renderTextCard(data);
    } else if (type == 'videoCollectionWithBrief') {
      return VideoCollectionWithBriefWidget(data);
    } else if (type == 'briefCard') {
      return _renderBriefAuthorCard(data);
    } else if (type == 'DynamicInfoCard') {
      return DynamicInfoCardWidget(data);
    } else {
      return new Text(type, style: TextStyle(color: Colors.green));
    }
  }

  _renderBriefCard(data, BuildContext context) {
    return BriefCardWidget(
        icon: data['image'],
        title: data['title'],
        onTap: () {
          String actionUrl = data['actionUrl'];
          print('$actionUrl');
          if (actionUrl.startsWith('eyepetizer://campaign/list')) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return CommonListPage(API.SPECIAL_TOPIC_ALL, title: '专题');
            }));
          } else if (actionUrl.startsWith('eyepetizer://tag')) {
            ActionViewUtils.actionTagInfoPage(
                API.TAG_INFO_TAB, context, actionUrl,
                type: 'tagInfo');
          } else if (actionUrl.startsWith('eyepetizer://category')) {
            ActionViewUtils.actionTagInfoPage(
                API.CATEGORY_INFO_TAB, context, actionUrl,
                type: 'categoryInfo');
          } else if (actionUrl.startsWith('eyepetizer://ranklist')) {
            //TODO 跳转至 全部排行
          }
        });
  }

  _renderBriefAuthorCard(data) {
    return Container(
      decoration: ActionViewUtils.renderBorderBottom(),
      padding: EdgeInsets.only(bottom: 15, top: 15),
      child: AuthorInfoWidget(
        name: data['title'],
        desc: data['description'],
        avatar: data['icon'],
        showCircleAvatar: true,
        isDark: true,
        id: data['id'].toString(),
        userType: data['ifPgc'] ? 'PGC' : 'NORMAL',
        rightBtnType: 'follow',
      ),
    );
  }

  _renderTextCard(data) {
    String type = data['type'];
    if (type == 'header5' || type == 'header2') {
      return TextCardWidget(
          title: data['text'],
          onTitleTap: () {
            String actionUrl = data['actionUrl'];
            if (actionUrl.startsWith('eyepetizer://tag')) {
              ActionViewUtils.actionTagInfoPage(
                  API.TAG_INFO_TAB, context, actionUrl,
                  type: 'tagInfo');
            } else if (actionUrl.startsWith('eyepetizer://ranklist')) {
              print('go to rankList');
            } else {
              print('  ------$actionUrl');
            }
          });
    } else if (type == 'footer3' || type == 'footer2' || type == 'footer1') {
      return TextCardWidget(
        rightBtnText: data['text'],
        align: MainAxisAlignment.end,
        onRightBtnTap: () {
          String actionUrl = data['actionUrl'];
          if (actionUrl.startsWith('eyepetizer://tag')) {
            ActionViewUtils.actionTagInfoPage(
                API.TAG_INFO_TAB, context, actionUrl,
                type: 'tagInfo');
          } else if (actionUrl.startsWith('eyepetizer://ranklist')) {
            print('go to rankList');
          } else {
            print('  ------$actionUrl');
          }
        },
      );
    } else {
      return Text(type, style: TextStyle(color: Colors.red));
    }
  }

  VideoSmallCardWidget _renderVideoSmallCard(data, BuildContext context) {
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

  _renderFollowCard(data, BuildContext context) {
    var _data = data['content']['data'];
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: FollowCardWidget(
          cover: _data['cover']['feed'],
          avatar: data['header']['icon'],
          title: data['header']['title'],
          desc: data['header']['description'],
          id: _data['author'] == null ? '' : _data['author']['id'].toString(),
          userType: 'PGC',
          duration: _data['duration'],
          onCoverTap: () {
            ActionViewUtils.actionVideoPlayPage(context,
                desc: _data['description'],
                id: _data['id'],
                category: _data['category'],
                author: _data['author'],
                cover: _data['cover'],
                consumption: _data['consumption'],
                title: _data['title']);
          },
        ));
  }

  @override
  bool registerScrollController() => widget.userLoadMore;

  @override
  renderItemRow(BuildContext context, int index) {
    return _renderItemRow(index, context);
  }

  @override
  String getType() => widget.type;

  @override
  String url() => widget.url;

  @override
  Map<String, String> getParams() {
    return widget.params;
  }

  @override
  Widget getAppBar() {
    if (widget.title == '') {
      return null;
    } else {
      return AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(widget.title, style: TextStyle(color: Colors.black)),
          centerTitle: true);
    }
  }
}
