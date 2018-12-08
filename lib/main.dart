import 'package:flutter/material.dart';
import 'views/FirstPage.dart';
import 'views/SecondPage.dart';
import 'views/ThirdPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(initialIndex: 0, length: 3, vsync: this);
    print(controller.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print('Build---');
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new FirstPage(),
          new SecondPage(),
          new ThirdPage(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: new Material(
          color: Colors.amberAccent,
          child: new TabBar(tabs: <Tab>[
            new Tab(text: '列表', icon: new Icon(Icons.home)),
            new Tab(text: '通知', icon: new Icon(Icons.message)),
            new Tab(text: '我的', icon: new Icon(Icons.cloud)),
          ],
          controller: controller,)),
    );
  }
}
