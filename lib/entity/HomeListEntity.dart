import 'package:flutter_app1/entity/HomeItemEntity.dart';

class HomeListEntity {
  List<HomeItemEntity> itemList;
  int count;

  HomeListEntity({this.itemList, this.count});

  @override
  String toString() {
    return 'HomeListEntity{itemList: $itemList, count: $count}';
  }
}
