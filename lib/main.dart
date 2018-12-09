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
  int _tabIndex = 0;
  var bodys = [new FirstPage(), new SecondPage(), new ThirdPage()];
  var titles = [new Text('列表'), new Text('通知'), new Text('我的')];

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
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
        appBar: new AppBar(
          title: titles[_tabIndex],
        ),
        body: bodys[_tabIndex],
        bottomNavigationBar: new BottomNavigationBar(
          fixedColor: Colors.blue,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home), title: titles[0]),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.message), title: titles[1]),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.cloud), title: titles[2]),
          ],
          //设置显示的模式
          type: BottomNavigationBarType.fixed,
          //设置当前的索引
          currentIndex: _tabIndex,
          //tabBottom的点击监听
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ));
  }
}
