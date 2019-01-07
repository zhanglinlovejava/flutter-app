import 'package:flutter/material.dart';
const double tabHeight = 45.0; //导航高度

class IconTap extends StatefulWidget {
  final String text;
  final String icon;
  final Color color;

  IconTap({Key key, this.text, this.icon, this.color}) : super(key: key);

  @override
  IconTapState createState() => IconTapState();
}

class IconTapState extends State<IconTap> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    Widget label = new Column(
      children: <Widget>[
        new Container(
          child: new Image(
            image: new AssetImage(widget.icon),
            height: 28,
            width: 28,
            fit: BoxFit.cover,
          ),
          margin: EdgeInsets.only(bottom: 1),
        ),
        new Text(
          widget.text,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: new TextStyle(color: widget.color,fontSize: 10,fontFamily: 'FZLanTing'),
        )
      ],
    );
    return new SizedBox(
      height: tabHeight,
      child: new Center(
        child: label,
        widthFactor: 1.0,
      ),
    );
  }
}
