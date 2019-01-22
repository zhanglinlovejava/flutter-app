import 'package:flutter/material.dart';
import 'package:flutter_open/pages/VideoPlayPage.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import '../api/API.dart';
import '../pages/StickyHeaderTabPage.dart';
import '../pages/CommonListPage.dart';
import '../pages/WebViewPage.dart';
import '../pages/CommonTabListPage.dart';
import '../pages/LightTopicPage.dart';
import '../event/EventUtils.dart';
import '../event/Events.dart';

class ActionViewUtils {
  static actionVideoPlayPage(BuildContext context, int id) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return new VideoPlayPage(id);
    }));
  }

  static void actionTagInfoPage(
      String url, BuildContext context, String actionUrl,
      {var follow, String type}) {
    String tagId;
    if (follow == null) {
      tagId = StringUtil.getTagIdFromActionUrl(actionUrl);
    } else {
      tagId = follow['itemId'].toString();
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Map<String, String> params = new Map();
      params['id'] = tagId;
      return StickyHeaderTabPage(url: url, params: params, type: type);
    }));
  }

  static renderGradientBg(colors, double radius) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter));
  }

  static renderBorderBottom({Color borderColor = const Color(0xffeeeeee)}) {
    return BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)));
  }

  static buildDuration(int duration) {
    return new Positioned(
        right: 10,
        bottom: 10,
        child: new Container(
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color.fromRGBO(0, 0, 0, 0.8),
          ),
          child: Text(
            StringUtil.formatDuration(duration),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: 'FZLanTing'),
          ),
        ));
  }

  static buildAppBar(
      {String title,
      List<Widget> actions = const [],
      TextStyle titleStyle = const TextStyle(),
      double elevation = 4,
      bool showTopLoading = false}) {
    if (title == null || title == '') {
      return null;
    } else {
      return AppBar(
          elevation: elevation,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(title, style: titleStyle.copyWith(color: Colors.black)),
          centerTitle: true,
          actions: actions);
    }
  }

  static void actionByActionUrl(BuildContext context, String actionUrl,
      {String title = '', int id = 0}) {
    if (actionUrl.startsWith('eyepetizer://lightTopic/detail')) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LightTopicPage(
          topicId: id,
          title: title,
        );
      }));
    } else if (actionUrl.startsWith('eyepetizer://feed')) {
      print('eyepetizer://feed-$actionUrl');
    } else if (actionUrl.startsWith('eyepetizer://homepage/selected')) {
      EventUtils.fire(UpdateMainTabEvent(0));
      EventUtils.fire(UpdateHomeTabEvent(2));
    } else if (actionUrl.startsWith('eyepetizer://campaign/list')) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return CommonListPage(API.SPECIAL_TOPIC_ALL, title: '专题');
      }));
    } else if (actionUrl.startsWith('eyepetizer://tag')) {
      ActionViewUtils.actionTagInfoPage(API.TAG_INFO_TAB, context, actionUrl,
          type: 'tagInfo');
    } else if (actionUrl.startsWith('eyepetizer://ranklist')) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return CommonTabListPage(API.RANK_LIST, title: 'eyepetizer');
      }));
    } else if (actionUrl.startsWith('eyepetizer://common')) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        String url = StringUtil.getValueFromActionUrl(actionUrl, 'url');
        String title = StringUtil.getValueFromActionUrl(actionUrl, 'title');
        return CommonListPage(url, title: title ?? '猜你喜欢');
      }));
    } else if (actionUrl.startsWith('eyepetizer://webview')) {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (BuildContext context) {
        String url = StringUtil.getValueFromActionUrl(actionUrl, 'url');
        return WebViewPage(url: url, title: title);
      }));
    } else if (actionUrl.startsWith('eyepetizer://category')) {
      ActionViewUtils.actionTagInfoPage(
          API.CATEGORY_INFO_TAB, context, actionUrl,
          type: 'categoryInfo');
    } else if (actionUrl.startsWith('eyepetizer://categories/all')) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return CommonListPage(API.CATEGORY_ALL,
            title: '全部分类', userLoadMore: false);
      }));
    } else if (actionUrl.startsWith('eyepetizer://pgcs/all')) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return CommonListPage(API.ALL_PGC, title: '全部作者');
      }));
    } else if (actionUrl.startsWith('eyepetizer://detail')) {
      String videoId = StringUtil.getTagIdFromActionUrl(actionUrl);
      print('$videoId');
      ActionViewUtils.actionVideoPlayPage(context, int.parse(videoId));
    } else {
      print('  ------$actionUrl');
    }
  }
}
