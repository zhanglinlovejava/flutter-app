import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/component/loading/loading_view.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_open/component/widgets/LoadErrorWidget.dart';
import 'package:flutter_open/component/widgets/image/CustomImage.dart';
import '../pages/StickyHeaderTabPage.dart';
import '../api/API.dart';

class UgcPicturePreviewWidget extends StatefulWidget {
  final index;
  final String resourceType;
  final int id;

  UgcPicturePreviewWidget({
    this.index = 0,
    @required this.resourceType,
    @required this.id,
  });

  @override
  _UgcPicturePreviewWidget createState() => _UgcPicturePreviewWidget();
}

class _UgcPicturePreviewWidget extends State<UgcPicturePreviewWidget>
    with SingleTickerProviderStateMixin {
  var _data;
  TabController _tabController;
  VoidCallback tabListener;
  int currentIndex = 0;
  bool showInfoView = true;
  LoadingStatus _status = LoadingStatus.loading;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    tabListener = () {
      currentIndex = _tabController.index;
      setState(() {});
    };
    _fetchUGCInfo();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.black,
      margin: EdgeInsets.only(top: 20),
      child: LoadingView(
          status: _status,
          loadingContent: PlatformAdaptiveProgressIndicator(
            strokeWidth: 2,
          ),
          errorContent: LoadErrorWidget(onRetryFunc: () {
            _fetchUGCInfo();
          }),
          successContent: _data == null
              ? new Container()
              : Stack(
                  alignment: Alignment(0, 1),
                  children: <Widget>[
                    TabBarView(
                        controller: _tabController,
                        children: _renderImagesView(context)),
                    Positioned(
                      top: 10,
                      child: Offstage(
                        offstage: _data['urls'].length <= 1,
                        child: Text(
                            '${(currentIndex + 1)}/${_data['urls'].length}',
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
                )),
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
              name: _data['owner']['nickname'],
              avatar: _data['owner']['avatar'],
              id: _data['owner']['uid'].toString(),
              userType: _data['owner']['userType'],
              rightBtnType: 'follow',
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                _data['description'],
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
          itemCount: (_data['tags'] ?? []).length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: new Container(
                margin: EdgeInsets.only(right: 5),
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(200, 200, 200, 0.50),
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: Text(
                  _data['tags'][index]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  Map<String, String> params = new Map();
                  params['id'] = _data['tags'][index]['id'].toString();
                  return StickyHeaderTabPage(
                      url: API.TAG_INFO_TAB, params: params, type: 'tagInfo');
                }));
              },
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
                  _data['consumption']['collectionCount'].toString(),
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
                  _data['consumption']['replyCount'].toString(),
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
    _data['urls'].forEach((url) {
      imageViews.add(GestureDetector(
        onTap: () {
          setState(() {
            showInfoView = !showInfoView;
          });
        },
        child: new Container(
          child: CustomImage(
            url,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.contain,
            showLoading: true,
            placeHolePath: '',
          ),
        ),
      ));
    });
    return imageViews;
  }

  _fetchUGCInfo() async {
    Map<String, String> params = new Map();
    params['resourceType'] = widget.resourceType;
    await HttpController.getInstance().get('v2/video/${widget.id}', (data) {
      _data = data;
      if (mounted) {
        _tabController =
            TabController(length: _data['urls'].length, vsync: this);
        _tabController.animateTo(currentIndex);
        _tabController.addListener(tabListener);
        _status = LoadingStatus.success;
        setState(() {});
      }
    }, errorCallback: (error) {
      _status = LoadingStatus.error;
      if (mounted) {
        setState(() {});
      }
    }, params: params);
  }
}
