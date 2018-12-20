import 'package:flutter/material.dart';
import 'package:flutter_app1/views/base/BaseAliveState.dart';

class CategoryPage extends StatefulWidget {
  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends BaseAliveState<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("分类"),
    );
  }
}
