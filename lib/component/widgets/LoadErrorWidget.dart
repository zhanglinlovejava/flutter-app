import 'package:flutter/material.dart';

class LoadErrorWidget extends StatelessWidget {
  final VoidCallback onRetryFunc;
  final String errMsg;

  LoadErrorWidget({@required this.onRetryFunc, this.errMsg = '出错了'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: new GestureDetector(
        onTap: onRetryFunc,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: new Icon(
                Icons.error,
                color: Colors.red,
              ),
              margin: EdgeInsets.only(bottom: 10),
            ),
            Text(
              errMsg,
              style: new TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
