import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_module/grid/GridListDemo.dart';
import 'package:flutter_module/page/LayoutBuilderDemo.dart';
import 'package:flutter_module/page/ScaffoldRoute.dart';
import 'package:flutter_module/page/stack.dart';

import 'flutter2android/HomePageCallback.dart';
import 'list/Product.dart';
import 'list/ProductListPage.dart';
import 'material_demo_types.dart';

void main() => runApp(_createWidget(window.defaultRouteName));

/// StatelessWidget 的 build 函数代码如下：
/// 业务逻辑可以放到构造方法中，避免重复多次调用
Widget _createWidget(String routeName) {
  //获取启动传递的参数
  print("routeName= $routeName");

  return const MyApp();
}

/*
 * StatelessWidget 派生的组件是无状态组件，
 * 无状态组件只是在构建的时候渲染一次，不支持动态变化，即无法通过其他用户操作重绘组件
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // build 在每次界面刷新的时候都会调用，所以不要在 build 里写业务逻辑
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Shared App Handler',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const ScaffoldRoute(),
        // 注册Flutter 路由
        '/second': (context) => const MyHomePage2(
              title: '测试Android、Flutter交互',
            ),
        '/third': (context) => const ShoppingList(
              products: [
                Product(name: 'Eggs'),
                Product(name: 'Flour'),
                Product(name: 'Chocolate chips'),
              ],
            ),
        '/four': (context) => const GridListDemo(type: GridListDemoType.header),
        '/five': (context) => const StackDemo(),
        '/six': (context) => const LayoutBuilderRoute(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
