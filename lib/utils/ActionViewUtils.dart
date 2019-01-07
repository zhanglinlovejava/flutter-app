import 'package:flutter/material.dart';
import 'package:flutter_open/pages/VideoPlayPage.dart';
import 'package:flutter_open/utils/StringUtil.dart';

class ActionViewUtils {
  static actionVideoPlayPage(BuildContext context, data) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return new VideoPlayPage(data);
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
