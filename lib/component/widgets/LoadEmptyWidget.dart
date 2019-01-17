import 'package:flutter/material.dart';

class LoadEmptyWidget extends StatelessWidget {
  final VoidCallback onRetryFunc;
  final String emptyMsg;

  LoadEmptyWidget({@required this.onRetryFunc, this.emptyMsg = '暂无数据'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: new GestureDetector(
        onTap: onRetryFunc,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: new Image.asset(
                'asset/images/empty_logo.png',
                width: 30,
                height: 30,
              ),
            ),
            Text(
              emptyMsg,
              style: new TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontFamily: 'FZLanTing',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
