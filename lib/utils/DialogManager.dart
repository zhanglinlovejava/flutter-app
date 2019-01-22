import 'package:flutter/material.dart';
import '../Constants.dart';
import 'ActionViewUtils.dart';

class DialogManger {
  static List<String> _shareActions = [
    'wx',
    'friend',
    'sina',
    'qq',
    'qqzone',
    'more'
  ];

  static Widget buildShareLayout(Function onTap) {
    return Container(
        decoration: ActionViewUtils.renderBorderBottom(),
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _shareActions.map((item) {
            String label = '';
            AssetImage image;
            switch (item) {
              case 'wx':
                label = '微信';
                image = ConsImages.wx;
                break;
              case 'friend':
                label = '朋友圈';
                image = ConsImages.wxFriend;
                break;
              case 'sina':
                label = '微博';
                image = ConsImages.sina;
                break;
              case 'qq':
                label = 'QQ';
                image = ConsImages.qq;
                break;
              case 'qqzone':
                label = 'QQ空间';
                image = ConsImages.qqZone;
                break;
              case 'more':
                label = '更多';
                image = ConsImages.more;
                break;
            }
            return _renderShareActionItem(image, label, item, onTap);
          }).toList(),
        ));
  }

  static Widget _renderShareActionItem(
      AssetImage image, String label, String type, Function onTap) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(type);
        }
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Image(image: image, width: 25, height: 25),
          ),
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 12))
        ],
      ),
    );
  }

  static renderCenterButton(String text, {Function onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        decoration: ActionViewUtils.renderBorderBottom(),
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Text(text,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontFamily: ConsFonts.fzFont)),
      ),
    );
  }

  static showDialog(BuildContext context, List<Widget> children) async {
    children.add(DialogManger.renderCenterButton('取消', onTap: () async {
      Navigator.pop(context);
    }));
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
        });
  }
}
