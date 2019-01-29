import 'package:flutter/material.dart';
import '../../../Constants.dart';
import 'package:flutter_open/component/dialog/DialogManager.dart';
import '../../../pages/CollectionPage.dart';

class ShareBtnWidget extends StatefulWidget {
  final double size;
  final int colorType; //0 默认灰色  1，白色  ， -1 黑色
  final bool showRightText;
  final String actionType;
  final VoidCallback onCacheVideo;
  final VoidCallback onSaveImage;

  ShareBtnWidget(
      {this.size = 20,
      this.colorType = 0,
      this.showRightText = false,
      this.actionType = ShareType.video,
      this.onCacheVideo,
      this.onSaveImage});

  @override
  _ShareBtnWidgetState createState() => _ShareBtnWidgetState();
}

class _ShareBtnWidgetState extends State<ShareBtnWidget> {
  int _colorType;
  AssetImage _assetImage;
  Color _textColor;

  @override
  void initState() {
    super.initState();
    _colorType = widget.colorType;
    _initAssetImage();
  }

  _initActions() {
    List<Widget> actions = [];
    String type = widget.actionType;
    if (widget.actionType == ShareType.share) {
      actions.add(DialogManger.renderCenterButton('分享'));
    }
    actions.add(DialogManger.buildShareLayout((type) {
      print('点击了分享$type');
      Navigator.pop(context);
    }));
    if (type == ShareType.video) {
      actions.add(DialogManger.renderCenterButton('缓存视频', onTap: () async {
        Navigator.pop(context);
        if (widget.onCacheVideo != null) widget.onCacheVideo();
      }));
    }
    if (type == ShareType.picture) {
      actions.add(DialogManger.renderCenterButton('举报作品', onTap: () async {
        Navigator.pop(context);
      }));
      actions.add(DialogManger.renderCenterButton('保存图片', onTap: () async {
        Navigator.pop(context);
        if (widget.onSaveImage != null) widget.onSaveImage();
      }));
    }
    if (type == ShareType.authorVideo) {
      actions.add(DialogManger.renderCenterButton('关注作者', onTap: () async {
        Navigator.pop(context);
      }));
      actions.add(DialogManger.renderCenterButton('缓存视频', onTap: () async {
        Navigator.pop(context);
        if (widget.onCacheVideo != null) widget.onCacheVideo();
      }));
    }
    return actions;
  }

  void _initAssetImage() {
    if (_colorType == 0) {
      _assetImage = ConsImages.shareGrey;
      _textColor = Colors.grey;
    } else if (_colorType == 1) {
      _assetImage = ConsImages.shareWhite;
      _textColor = Colors.white;
    } else if (_colorType == -1) {
      _assetImage = ConsImages.shareBlack;
      _textColor = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.actionType == ShareType.goToCache) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return CollectionPage(DBSource.cache, title: '我的缓存');
          }));
          return;
        }
        DialogManger.showDialog(context, _initActions());
      },
      child: Container(
          padding: EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 7),
                child: Image(
                    image: _assetImage,
                    width: widget.size,
                    height: widget.size),
              ),
              widget.showRightText
                  ? Text('缓存',
                      style: TextStyle(
                          color: _textColor,
                          fontFamily: ConsFonts.fzFont,
                          fontSize: 12))
                  : Container()
            ],
          )),
    );
  }

  @override
  void didUpdateWidget(ShareBtnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.colorType != _colorType) {
      _colorType = widget.colorType;
      _initAssetImage();
      setState(() {});
    }
  }
}
