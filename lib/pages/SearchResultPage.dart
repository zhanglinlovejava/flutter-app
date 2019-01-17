import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/TextCardWidget.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/pages/BaseLoadListSate.dart';
import 'package:flutter_open/component/widgets/TheEndWidget.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/pages/CommonListPage.dart';
import '../utils/StringUtil.dart';
import '../api/API.dart';

class SearchResultPage extends StatefulWidget {
  final String url;
  final Map<String, String> params;
  final String title;

  SearchResultPage(this.url,
      {this.params, this.title = ''});

  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends BaseLoadListSate<SearchResultPage> {
  _renderItemRow(int index, BuildContext context) {
    return Container(
      child: _renderCommonItem(index, context),
    );
  }

  _renderCommonItem(int index, BuildContext context) {
    String type = itemList[index]['type'];
    var data = itemList[index]['data'];
    if (hasNoMoreData && index == itemList.length - 1) {
      return TheEndWidget(color: 0xff000000);
    } else if (type == 'followCard') {
      return _renderFollowCard(data, context);
    } else if (type == 'videoSmallCard') {
      return _renderVideoSmallCard(data, context);
    } else if (type == 'textCard') {
      String actionUrl = data['actionUrl'];
      return TextCardWidget(
          title: data['text'],
          rightBtnText: actionUrl == null ? '' : '显示全部',
          align: MainAxisAlignment.spaceBetween,
          onRightBtnTap: () {
            Map<String, String> params =
                StringUtil.getParamsFromUrl(actionUrl) ?? Map();
            params.addAll(widget.params);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return CommonListPage(API.SEARCH_ALL_USER,
                  params: params, title: '全部搜索的${data['text']}');
            }));
          });
    } else if (type == 'briefCard') {
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
    } else {
      return new Text(type, style: TextStyle(color: Colors.red));
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
  bool registerScrollController() => true;

  @override
  renderItemRow(BuildContext context, int index) {
    return _renderItemRow(index, context);
  }

  @override
  String getType() => 'common';

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
