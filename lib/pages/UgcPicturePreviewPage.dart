import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';

class UgcPicturePreviewWidget extends StatefulWidget {
  final data;
  final index;

  UgcPicturePreviewWidget(this.data, {this.index});

  @override
  _UgcPicturePreviewWidget createState() => _UgcPicturePreviewWidget();
}

class _UgcPicturePreviewWidget extends State<UgcPicturePreviewWidget>
    with SingleTickerProviderStateMixin {
  List<dynamic> images = [];
  var data;
  TabController tabController;
  VoidCallback tabListener;
  int currentIndex = 0;
  bool showInfoView = true;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    images = data['urls'];
    currentIndex = widget.index;
    tabController = TabController(length: images.length, vsync: this);
    tabController.animateTo(currentIndex);
    tabListener = () {
      currentIndex = tabController.index;
      setState(() {});
    };
    tabController.addListener(tabListener);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.black,
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        alignment: Alignment(0, 1),
        children: <Widget>[
          TabBarView(
              controller: tabController, children: _renderImagesView(context)),
          Positioned(
            top: 10,
            child: Offstage(
              offstage: images.length <= 1,
              child: Text('${(currentIndex + 1)}/${images.length}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal)),
            ),
          ),
          _renderCloseBtn(),
          _renderInfo()
        ],
      ),
    );
  }

  _renderInfo() {
    return Offstage(
      offstage: !showInfoView,
      child: new Container(
        height: 200,
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AuthorInfoWidget(
              name: data['owner']['nickname'],
              avatar: data['owner']['avatar'],
              id: data['owner']['uid'].toString(),
              userType: data['owner']['userType'],
              rightBtnType: 'follow',
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                data['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
            _renderTags(),
            _renderBottomBar()
          ],
        ),
      ),
    );
  }

  _renderTags() {
    return new Container(
      height: 25,
      margin: EdgeInsets.only(bottom: 5, top: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (data['tags'] ?? []).length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              margin: EdgeInsets.only(right: 5),
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(200, 200, 200, 0.50),
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Text(
                data['tags'][index]['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
              ),
            );
          }),
    );
  }

  _renderBottomBar() {
    return new Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                size: 20,
                color: Colors.white,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  data['consumption']['collectionCount'].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              Icon(
                Icons.comment,
                size: 20,
                color: Colors.white,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  data['consumption']['replyCount'].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
          Icon(
            Icons.share,
            size: 20,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  _renderCloseBtn() {
    return Positioned(
        top: 20,
        left: 20,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Offstage(
              offstage: !showInfoView,
              child: new Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: new Container(
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 15,
                  ),
                ),
              )),
        ));
  }

  List<Widget> _renderImagesView(BuildContext context) {
    List<Widget> imageViews = [];
    images.forEach((url) {
      imageViews.add(GestureDetector(
        onTap: () {
          setState(() {
            showInfoView = !showInfoView;
          });
        },
        child: new Container(
          child: Image.network(
            url,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ));
    });
    return imageViews;
  }
}
