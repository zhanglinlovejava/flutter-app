import 'package:flutter/material.dart';
import 'views/HomePage.dart';
import 'views/DiscoveryPage.dart';
import 'views/ThirdPage.dart';
import 'components/IconTap.dart';

void main() => runApp(MyApp());
const int INDEX_HOME = 0;
const int INDEX_MESSAGE = 1;
const int INDEX_MY = 2;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xffffffff),
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
    with SingleTickerProviderStateMixin{
  TabController controller;
  VoidCallback onChange;
  int _currentIndex = 0;
  var titles = <String>['列表', '发现', '通知'];
  var bodys = [];

  _MyHomePageState() {
    var first = new HomePage();
    var second = new DiscoveryPage();
    var third = new ThirdPage();
    bodys = [first, second, third];
    controller = new TabController(length: 3, vsync: this);
    onChange = () {
      setState(() {
        _currentIndex = controller.index;
      });
    };
    controller.addListener(onChange);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(onChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[new HomePage(), new DiscoveryPage(), new ThirdPage()],
        controller: controller,
        physics: new NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: new TabBar(
            controller: controller,
            indicatorColor: Colors.transparent,
            tabs: <IconTap>[
          new IconTap(
            icon: _currentIndex == INDEX_HOME
                ? 'images/home_s.png'
                : 'images/home_n.png',
            color: _currentIndex == INDEX_HOME
                ? const Color(0xFFFC9B84)
                : Colors.grey,
            text: titles[INDEX_HOME],
          ),
          new IconTap(
            icon: _currentIndex == INDEX_MESSAGE
                ? 'images/home_s.png'
                : 'images/home_n.png',
            color: _currentIndex == INDEX_MESSAGE
                ? const Color(0xFFFC9B84)
                : Colors.grey,
            text: titles[INDEX_MESSAGE],
          ),
          new IconTap(
            icon: _currentIndex == INDEX_MY
                ? 'images/home_s.png'
                : 'images/home_n.png',
            color: _currentIndex == INDEX_MY
                ? const Color(0xFFFC9B84)
                : Colors.grey,
            text: titles[INDEX_MY],
          )
        ]),
      ),
    );
  }
}
