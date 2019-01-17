import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/pages/UgcPicturePreviewPage.dart';

class DynamicResourceTypeCard extends StatelessWidget {
  final user;
  final simpleVideo;

  DynamicResourceTypeCard({this.user, this.simpleVideo});

  @override
  Widget build(BuildContext context) {
    return _renderCardByResourceType(context);
  }

  _renderVideoResource(BuildContext context) {
    return VideoSmallCardWidget(
      id: simpleVideo['id'],
      cover: simpleVideo['cover'] == null ? '' : simpleVideo['cover']['feed'],
      title: simpleVideo['title'],
      duration: simpleVideo['duration'],
      category: simpleVideo['category'] ?? '开眼推荐',
      onCoverTap: () {
        if (simpleVideo['onlineStatus'] == 'OFFLINE') {
          return;
        }
        ActionViewUtils.actionVideoPlayPage(context,
            desc: simpleVideo['description'],
            id: simpleVideo['id'],
            category: simpleVideo['category'],
            author: user,
            cover: simpleVideo['cover'],
            consumption: simpleVideo['consumption'],
            title: simpleVideo['title']);
      },
    );
  }

  _renderPictureResource(BuildContext context) {
    return VideoSmallCardWidget(
      cover: simpleVideo['cover']['feed'],
      title: simpleVideo['title'],
      category: simpleVideo['category'] ?? '开眼推荐',
      onCoverTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return UgcPicturePreviewWidget(
              resourceType: simpleVideo['resourceType'], id: simpleVideo['id']);
        }));
      },
    );
  }

  _renderCardByResourceType(BuildContext context) {
    String resourceType = simpleVideo['resourceType'];
    if (resourceType == 'ugc_video' || resourceType == 'video') {
      return _renderVideoResource(context);
    } else if (resourceType == 'ugc_picture') {
      return _renderPictureResource(context);
    } else {
      return Text(
        resourceType,
        style: TextStyle(color: Colors.red),
      );
    }
  }
}
