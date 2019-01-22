import 'package:flutter/material.dart';
import 'TextCardWidget.dart';
import 'BriefCardWidget.dart';
import '../../utils/StringUtil.dart';
import '../../utils/ActionViewUtils.dart';
import '../../pages/WebViewPage.dart';
import '../../pages/CommonTabListPage.dart';
import '../../pages/CommonListPage.dart';
import '../../api/API.dart';

class ColumnCardListWidget extends StatelessWidget {
  final String title;
  final List itemList;

  ColumnCardListWidget(this.title, this.itemList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextCardWidget(title: title, showTitleArrow: false),
          _renderColumnList(context)
        ],
      ),
    );
  }

  _renderColumnList(BuildContext context) {
    return new GridView.extent(
      shrinkWrap: true,
      maxCrossAxisExtent: (MediaQuery.of(context).size.width - 36) / 2,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 5 / 3,
      children: _renderItemView(context),
      physics: new NeverScrollableScrollPhysics(),
    );
  }

  _renderItemView(BuildContext context) {
    return itemList.map((item) {
      return BriefCardWidget(
        icon: item['data']['image'],
        title: item['data']['title'],
        desc: item['data']['description'],
        onTap: () {
          String actionUrl = item['data']['actionUrl'];
          ActionViewUtils.actionByActionUrl(context, actionUrl,title: item['data']['title']);
        },
      );
    }).toList();
  }
}
