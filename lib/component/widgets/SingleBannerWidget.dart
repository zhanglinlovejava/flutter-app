import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/pages/WebViewPage.dart';
import '../../pages/LightTopicPage.dart';
class SingleBannerWidget extends StatelessWidget {
  final   data;
  final double height;

  SingleBannerWidget(this.data, {this.height = 180});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String actionUrl = data['actionUrl'];
        if(actionUrl.startsWith('eyepetizer://lightTopic/detail')){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return LightTopicPage(topicId:data['id'] ,title:data['title'] ,);
              }));
        }else{
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (BuildContext context) {
            return WebViewPage();
          }));
        }
      },
      child: new Container(
          margin: EdgeInsets.only(bottom: 5, top: 5),
          height: height,
          decoration: ActionViewUtils.renderGradientBg([
            Color.fromRGBO(0, 0, 0, 0.2),
            Color.fromRGBO(0, 0, 0, 0),
            Color.fromRGBO(0, 0, 0, 0.2),
          ], 5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image.network(
              data['image'],
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          )),
    );
  }
}
