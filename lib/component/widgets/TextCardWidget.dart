import 'package:flutter/material.dart';
import '../../Constants.dart';

class TextCardWidget extends StatelessWidget {
  final String title;
  final String rightBtnText;
  final MainAxisAlignment align;
  final VoidCallback onRightBtnTap;
  final VoidCallback onTitleTap;
  final bool showTitleArrow;

  TextCardWidget(
      {this.title = '',
      this.showTitleArrow = true,
      this.rightBtnText = '',
      this.align = MainAxisAlignment.start,
      this.onRightBtnTap,
      this.onTitleTap});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: new Row(
        mainAxisAlignment: align,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (onTitleTap != null) {
                onTitleTap();
              }
            },
            child: Row(children: <Widget>[
              title == '' || title == null
                  ? new Container()
                  : new Text(
                      title,
                      style:
                          TextStyle(fontSize: 20, fontFamily: ConsFonts.fzFont),
                    ),
              showTitleArrow && (title != '' && title != null)
                  ? new Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Image(
                        image: ConsImages.rightGreyArrow,
                        width: 10,
                        height: 15,
                      ),
                    )
                  : new Container()
            ]),
          ),
          rightBtnText == '' || rightBtnText == null
              ? new Container()
              : GestureDetector(
                  onTap: () {
                    if (onRightBtnTap != null) {
                      onRightBtnTap();
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        rightBtnText,
                        style: TextStyle(
                            color: Color(0xff5087c8),
                            fontSize: 14,
                            fontFamily: ConsFonts.fzFont),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          child: Image(
                            image: ConsImages.rightBlueArrow,
                            width: 15,
                            height: 15,
                          ))
                    ],
                  ))
        ],
      ),
    );
  }
}
