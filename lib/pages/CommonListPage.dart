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
import '../component/widgets/BriefCardWidget.dart';
import '../component/widgets/ColumnCardListWidget.dart';
import '../entity/CollectionEntity.dart';
import '../Constants.dart';
import '../db/DBManager.dart';
class CommonListPage extends StatefulWidget {
  final String url;
  final bool userLoadMore;
  final Map<String, String> params;
  final String type;
  final String title;

  CommonListPage(this.url,
      {this.userLoadMore = true,
      this.params,
      this.type = 'common',
      this.title = ''});

  _CommonListPageState createState() => _CommonListPageState();
}

class _CommonListPageState extends BaseLoadListSate<CommonListPage> {
  DBManager _db;

  initState() {
    super.initState();
    _db = DBManager();
  }

  _renderItemRow(int index, BuildContext context) {
    if (widget.type == 'common') {
      return _renderCommonItem(index, context);
    } else if (widget.type == 'message') {
      return MessageItemWidget(itemList[index]);
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
        type == 'videoCollectionOfHorizontalScrollCard' ||
        type == 'specialSquareCardCollection') {
      return _renderSquareCardCollectionWidget(data, context);
    } else if (type == 'squareCard' || type == 'rectangleCard') {
      return _renderBriefCard(data, context);
    } else if (type == 'blankCard') {
      return SizedBox(height: 15);
    } else if (type == 'followCard') {
      return _renderFollowCard(data, context);
    } else if (type == 'videoSmallCard') {
      return _renderVideoSmallCard(data, context);
    } else if (type == 'autoPlayFollowCard' || type == 'pictureFollowCard') {
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
    } else if (type == 'columnCardList') {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: ColumnCardListWidget(data['header']['title'], data['itemList']),
      );
    } else {
      return new Text(type, style: TextStyle(color: Colors.green));
    }
  }

  _renderSquareCardCollectionWidget(data, BuildContext context) {
    return SquareCardCollectionWidget(data, onRightTap: () {
      ActionViewUtils.actionByActionUrl(context, data['header']['actionUrl'],
          title: data['header']['title']);
    }, onTitleTap: () {
      ActionViewUtils.actionByActionUrl(context, data['header']['actionUrl'],
          title: data['header']['title']);
    });
  }

  _renderBriefCard(data, BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.only(top: 10),
      child: BriefCardWidget(
          icon: data['image'],
          title: data['title'],
          onTap: () {
            ActionViewUtils.actionByActionUrl(context, data['actionUrl'],
                title: data['title']);
          }),
    );
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
        actionUrl: data['actionUrl'],
        rightBtnType: 'follow',
      ),
    );
  }

  _renderTextCard(data) {
    String type = data['type'];
    if (type == 'header5' ||
        type == 'header2' ||
        type == 'header4' ||
        type == 'header7') {
      String actionUrl = data['actionUrl'];
      if (actionUrl == null) {
        return TextCardWidget(title: data['text'], showTitleArrow: false);
      } else {
        return TextCardWidget(
          title: data['text'],
          align: MainAxisAlignment.spaceBetween,
          rightBtnText: data['rightText'],
          onTitleTap: () {
            ActionViewUtils.actionByActionUrl(context, actionUrl);
          },
          onRightBtnTap: () {
            ActionViewUtils.actionByActionUrl(context, actionUrl);
          },
        );
      }
    } else if (type == 'footer3' || type == 'footer2' || type == 'footer1') {
      return TextCardWidget(
        rightBtnText: data['text'],
        align: MainAxisAlignment.end,
        onRightBtnTap: () {
          ActionViewUtils.actionByActionUrl(context, data['actionUrl']);
        },
      );
    } else {
      return Text(type, style: TextStyle(color: Colors.red));
    }
  }

  VideoSmallCardWidget _renderVideoSmallCard(data, BuildContext context) {
    return VideoSmallCardWidget(
      showShareBtn: true,
      id: data['id'],
      cover: data['cover']['feed'],
      title: data['title'],
      duration: data['duration'],
      category: data['category'],
      onCacheVideo: () async {
        CollectionEntity ce = CollectionEntity(
          source: DBSource.cache,
          itemId: data['id'],
          type: 'video',
          cover: data['cover']['feed'],
          title: data['title'],
          duration: data['duration'],
          category: '已缓存',
        );
        await _db.saveCollection(ce);
      },
      onCoverTap: () {
        ActionViewUtils.actionVideoPlayPage(context, data['id']);
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
            ActionViewUtils.actionVideoPlayPage(context, _data['id']);
          },
          onCacheVideo: () async {
            CollectionEntity ce = CollectionEntity(
                source: DBSource.cache,
                title: _data['title'],
                category: '已缓存',
                type: 'video',
                duration: _data['duration'],
                cover: _data['cover']['feed'],
                itemId: _data['id']);
            await _db.saveCollection(ce);
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
    return ActionViewUtils.buildAppBar(title: widget.title);
  }
}
