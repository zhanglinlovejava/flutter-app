import 'package:flutter/material.dart';
import 'package:flutter_open/pages/VideoPlayPage.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import '../api/API.dart';
import '../pages/StickyHeaderTabPage.dart';

class ActionViewUtils {
  static actionVideoPlayPage(BuildContext context,  int id) {
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

  static renderBorderBottom() {
    return BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200], width: 1)));
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
      {String title = '',
      List<Widget> actions = const [],
      TextStyle titleStyle = const TextStyle(),
      double elevation = 4,
      bool showTopLoading = false}) {
    if (title == '' || title == null) {
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
}
