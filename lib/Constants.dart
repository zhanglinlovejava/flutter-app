import 'package:flutter/material.dart';

class Constants {
  static String uid = '302284422';
}

class ConsColors {
  static Color mainColor = Color(0xff5087c8);
}

class ConsFonts {
  static String fzFont = 'FZLanTing';
  static String lobFont = 'Lobster';
}

class ConsImages {
  static AssetImage rightBlueArrow =
      AssetImage('asset/images/arrow_right_blue.png');
  static AssetImage rightGreyArrow = AssetImage('asset/images/arrow_right.png');
  static AssetImage shareGrey = AssetImage('asset/images/share.png');
  static AssetImage shareWhite = AssetImage('asset/images/share_white.png');
  static AssetImage shareBlack = AssetImage('asset/images/share_black.png');
  static AssetImage qqZone = AssetImage('asset/images/qqzone.png');
  static AssetImage qq = AssetImage('asset/images/qq.png');
  static AssetImage wx = AssetImage('asset/images/wx.png');
  static AssetImage wxFriend = AssetImage('asset/images/wx_friend.png');
  static AssetImage sina = AssetImage('asset/images/sina.png');
  static AssetImage more = AssetImage('asset/images/more.png');
}

class ShareType{
  static const String video = 'video';
  static const String picture = 'picture';
  static const String authorVideo = 'authorVideo';
  static const String share = 'share';
  static const String goToCache = 'goToCache';
}
class DBSource{
  static const String cache = 'cache';
  static const String collection = 'collection';
  static const String watch = 'watch';
}
