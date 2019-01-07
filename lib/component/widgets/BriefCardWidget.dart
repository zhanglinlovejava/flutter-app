import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class BriefCardWidget extends StatelessWidget {
  final String icon;
  final String title;

  BriefCardWidget({@required this.icon, @required this.title});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Container(
            foregroundDecoration: ActionViewUtils.renderGradientBg([
              Color.fromRGBO(0, 0, 0, 0.3),
              Color.fromRGBO(0, 0, 0, 0.3),
            ], 3),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              child: Image.network(
                icon,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: 'FZLanTing'),
          )
        ],
      ),
    );
  }
}
