import 'package:flutter/material.dart';

class LoadErrorWidget extends StatelessWidget {
  final VoidCallback onRetryFunc;
  final String errMsg;

  LoadErrorWidget({@required this.onRetryFunc, this.errMsg = '出错了，请稍点击重试'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: new GestureDetector(
        onTap: () {
          if (onRetryFunc != null) onRetryFunc();
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('asset/images/empty_logo.png',
                  width: 50, height: 50),
              margin: EdgeInsets.only(bottom: 10),
            ),
            Text(
              errMsg,
              style: new TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
