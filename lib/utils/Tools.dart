import 'package:flutter/material.dart';

class Tools {
  //获取状态高度
  static getStatusHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
}
