import 'package:flutter/material.dart';
import 'package:flutter_module/grid/GridListDemo.dart';
import 'package:flutter_module/page/HomePage.dart';

import '../material_demo_types.dart';
import '../page/DialogPageDemo.dart';

final _tabDataList = <_TabData>[
  _TabData(
      tab: const Text('推荐'),
      body: const GridListDemo(type: GridListDemoType.header)),
  _TabData(tab: const Text('VIP'), body: const MyHomePage(title: 'tab layout')),
  _TabData(tab: const Text("Dialog_Demo"), body: const DialogPageDemo())
];

/*
 * 模拟android viewpager
 */
class ViewPageDemo extends StatefulWidget {
  const ViewPageDemo({super.key});

  @override
  State<StatefulWidget> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPageDemo> {
  final tabBarList = _tabDataList.map((item) => item.tab).toList();
  final List<Widget> tabBarViewList =
      _tabDataList.map((item) => item.body).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabBarList.length,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
              alignment: Alignment.centerLeft,
              color: Colors.black,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.red,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelStyle: const TextStyle(fontSize: 18),
                labelColor: Colors.red,
                labelStyle: const TextStyle(fontSize: 20),
                tabs: tabBarList,
              ),
            ),
            Expanded(flex: 1, child: TabBarView(children: tabBarViewList))
          ],
        ));
  }
}

class _TabData {
  final Widget tab;
  final Widget body;

  _TabData({required this.tab, required this.body});
}
