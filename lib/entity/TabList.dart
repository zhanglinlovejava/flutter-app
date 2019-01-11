import 'package:flutter_open/entity/TabInfo.dart';

class TabList {
  List<TabInfo> _tabList = [];

  TabList(this._tabList);

  List<TabInfo> get tabList => _tabList;

  TabList.map(obj) {
    _tabList = [];
    if (obj != null) {
      obj.forEach((tabInfo) {
        _tabList.add(TabInfo.map(tabInfo));
      });
    }
  }

  Map<String,dynamic> toListMap() {
    Map<String,dynamic> map = new Map();
    List<dynamic> list = [];
    _tabList.forEach((tabInfo) {
      list.add(tabInfo.toMap());
    });
    map['tabList'] = list;
    return map;
  }
}
