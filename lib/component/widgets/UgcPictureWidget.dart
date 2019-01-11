import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/pages/UgcPicturePreviewPage.dart';

class UgcPictureWidget extends StatelessWidget {
  final data;

  UgcPictureWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _renderItem(context),
    );
  }

  _renderItem(BuildContext context) {
    List<dynamic> urls = data['urls'] ?? [];
    if (urls.length == 1) {
      return GestureDetector(
        onTap: () {
          _actionToImagePreviewPage(context, 0);
        },
        child: new Container(
          decoration: ActionViewUtils.renderGradientBg(
              [Color.fromRGBO(0, 0, 0, 0.2), Color.fromRGBO(0, 0, 0, 0.2)], 5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image.network(
              urls[0],
              fit: BoxFit.cover,
              height: 190,
              width: double.infinity,
            ),
          ),
        ),
      );
    } else if (urls.length == 2) {
      double width = MediaQuery.of(context).size.width / 2 - 19;
      return new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            renderItem(context, 0, urls, [5, 0, 0, 5],
                width: width, height: 140),
            renderItem(context, 1, urls, [0, 5, 5, 0],
                width: width, height: 140),
          ],
        ),
      );
    } else if (urls.length == 3) {
      double width = MediaQuery.of(context).size.width / 2 - 19;
      return new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            renderItem(context, 0, urls, [5, 0, 0, 5],
                width: width, height: 184),
            new Column(
              children: <Widget>[
                renderItem(context, 1, urls, [0, 5, 0, 0],
                    width: width, height: 90),
                renderItem(context, 2, urls, [0, 0, 5, 0],
                    width: width, height: 90),
              ],
            )
          ],
        ),
      );
    } else if (urls.length >= 4) {
      double width = MediaQuery.of(context).size.width / 2 - 19;
      double height = 90;
      return new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                renderItem(context, 0, urls, [5, 0, 0, 0],
                    height: height, width: width),
                renderItem(context, 1, urls, [0, 5, 0, 0],
                    height: height, width: width),
              ],
            ),
            Row(
              children: <Widget>[
                renderItem(context, 2, urls, [0, 0, 0, 5],
                    height: height, width: width),
                renderItem(context, 3, urls, [0, 0, 5, 0],
                    height: height, width: width),
              ],
            )
          ],
        ),
      );
    }
  }

  Container renderItem(
      BuildContext context, int index, List<dynamic> urls, List<double> borders,
      {double height = 100, double width = 200}) {
    int lastCount = urls.length - 4;
    bool showShadow = lastCount > 0 && index == 3;
    return new Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.2),
        borderRadius: _renderBorderRadius(borders),
      ),
      child: GestureDetector(
        onTap: () {
          _actionToImagePreviewPage(context, index);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Container(
                foregroundDecoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, showShadow ? 0.4 : 0),
                  borderRadius: _renderBorderRadius(borders),
                ),
                child: ClipRRect(
                  borderRadius: _renderBorderRadius(borders),
                  child: Image.network(
                    urls[index],
                    fit: BoxFit.cover,
                    height: height,
                    width: width,
                  ),
                )),
            showShadow
                ? Text(
                    '+$lastCount',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                : new Container()
          ],
        ),
      ),
    );
  }

  BorderRadius _renderBorderRadius(List<double> borders) {
    return BorderRadius.only(
                  topLeft: Radius.circular(borders[0]),
                  topRight: Radius.circular(borders[1]),
                  bottomRight: Radius.circular(borders[2]),
                  bottomLeft: Radius.circular(borders[3]),
                );
  }

  _actionToImagePreviewPage(BuildContext context, int index) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return UgcPicturePreviewWidget(data, index: index);
    }));
  }
}
