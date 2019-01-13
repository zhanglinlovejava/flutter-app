import 'package:flutter/material.dart';
import 'package:flutter_open/pages/VideoPlayPage.dart';
import 'package:flutter_open/utils/StringUtil.dart';

class ActionViewUtils {
  static actionVideoPlayPage(BuildContext context,
      {var consumption,
      var author,
      var cover,
      String title,
      String category,
      String playUrl,
      String desc,
      int id}) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return new VideoPlayPage(
        category: category,
        consumption: consumption,
        author: author,
        cover: cover,
        id: id.toString(),
        title: title,
        playUrl: playUrl,
        desc: desc,
      );
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
        border:
            Border(bottom: BorderSide(color: Colors.grey[200], width: 0.5)));
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
}