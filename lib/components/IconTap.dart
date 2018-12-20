import 'package:flutter/material.dart';

const double tabHeight = 48.0; //导航高度
const double marginBottom = 2.0; //图标与文字的间隔

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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          child: new Image(
            image: new AssetImage(widget.icon),
            height: 25,
            width: 25,
          ),
          margin: const EdgeInsets.only(bottom: marginBottom),
        ),
        new Text(
          widget.text,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: new TextStyle(color: widget.color,fontSize: 12),
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
