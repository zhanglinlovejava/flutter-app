import 'package:flutter/material.dart';
import 'package:flutter_app1/api/HttpController.dart';

class List extends StatefulWidget {
  @override
  ListState createState() {
    return ListState();
  }
}

class ListState extends State<List> {
  getData() async {
    var url = '';
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          child: new Container(
            padding: EdgeInsets.all(10),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Image(
                      image: new AssetImage('images/avatar.jpg'),
                      height: 60,
                      width: 60,
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 5),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              '标题',
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            new Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 100.0,
                              margin: EdgeInsets.only(top: 10),
                              child: new Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text('新闻描述',
                                      style: new TextStyle(fontSize: 14)),
                                  new Text('2018-09-23',
                                      style: new TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                          ]),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
