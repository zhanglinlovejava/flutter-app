import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/dynamicInfo/DynamicReplyCardWidget.dart';
import 'package:flutter_open/component/widgets/dynamicInfo/DynamicFollowCardWidget.dart';
import 'package:flutter_open/component/widgets/dynamicInfo/DynamicVideoCardWidget.dart';

class DynamicInfoCardWidget extends StatelessWidget {
  final data;

  DynamicInfoCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    String dataType = data['dataType'];
    if (dataType == 'DynamicFollowCard') {
      return DynamicFollowCardWidget(data);
    } else if (dataType == 'DynamicReplyCard') {
      return DynamicReplyCardWidget(data);
    }else if(dataType == 'DynamicVideoCard'){
      return DynamicVideoCardWidget(data);
    }
    return Text(dataType);
  }
}
