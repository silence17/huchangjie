import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_module/page/HomePage.dart';

import 'flutter2android/HomePageCallback.dart';
import 'list/Product.dart';
import 'list/ProductListPage.dart';

void main() => runApp(_createWidget(window.defaultRouteName));

Widget _createWidget(String routeName) {
  //获取启动传递的参数
  print("routeName= $routeName");

  return const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Shared App Handler',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const MyHomePage(
              title: '测试',
            ),
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
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
