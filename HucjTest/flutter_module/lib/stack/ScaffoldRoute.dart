import 'package:flutter/material.dart';
import 'package:flutter_module/page/HomePage.dart';

import '../list/Product.dart';
import '../list/ProductListPage.dart';
import 'LayoutBuilderDemo.dart';
import 'MyDrawer.dart';

/*
 * Scaffold脚手架
 */
class ScaffoldRoute extends StatefulWidget {
  const ScaffoldRoute({super.key});

  @override
  State<StatefulWidget> createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  int _selectIndex = 0;

  final bodyList = [
    const MyHomePage(title: '测试'),
    const LayoutBuilderRoute(),
    const ShoppingList(
      products: [
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips')
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //导航栏
        // appBar: AppBar(
        //   title: const Text("App Name"),
        //   actions: <Widget>[
        //     IconButton(onPressed: () {}, icon: const Icon(Icons.share))
        //   ],
        // ),
        //抽屉
        drawer: const MyDrawer(),

        //底部bar
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), label: 'Business'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
          ],
          currentIndex: _selectIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),

        //body
        //IndexedStack继承自Stack，它的作用是显示第index个child，其它child在页面上是不可见的，但所有child的状态都被保持
        body: IndexedStack(index: _selectIndex, children: bodyList));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }
}
