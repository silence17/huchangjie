import 'package:flutter/material.dart';

import '../utils/LayoutLogPrint.dart';

/*
 * 相当于自定义组件
 */
class ResponsiveColumn extends StatelessWidget {
  const ResponsiveColumn({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // 通过 LayoutBuilder 拿到父组件传递的约束，然后判断 maxWidth 是否小于200
    // 布局过程中拿到父组件传递的约束信息，然后我们可以根据约束信息动态的构建不同的布局。
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 200) {
          // 最大宽度小于200，显示单列
          return Column(mainAxisSize: MainAxisSize.min, children: children);
        } else {
          // 大于200，显示双列
          var _children = <Widget>[];
          for (var i = 0; i < children.length; i += 2) {
            if (i + 1 < children.length) {
              _children.add(Row(
                mainAxisSize: MainAxisSize.min,
                children: [children[i], children[i + 1]],
              ));
            } else {
              _children.add(children[i]);
            }
          }
          return Column(mainAxisSize: MainAxisSize.min, children: _children);
        }
      },
    );
  }
}

class LayoutBuilderRoute extends StatelessWidget {
  const LayoutBuilderRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _children = List.filled(6, const Text("A"));
    // Column在本示例中在水平方向的最大宽度为屏幕的宽度
    return Container(
        //BoxDecoration装饰器，可以在其子组件绘制前(或后)绘制一些装饰（Decoration），如背景、边框、渐变等。
        decoration: const BoxDecoration(
            // 渐变色
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 251, 240, 226),
          Color.fromARGB(255, 232, 233, 243),
          Color.fromARGB(255, 252, 232, 226),
          Color.fromARGB(255, 248, 225, 248),
          Color.fromARGB(255, 220, 230, 254)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Column(
          children: [
            // 限制宽度为190，小于 200
            // SizedBox(width: 190, child: ResponsiveColumn(children: _children)),
            ResponsiveColumn(children: _children),
            // 下面介绍
            const LayoutLogPrint(child: Text("xx")),

            const SizedBox(
              height: 100,
            ),

            Container(
              height: 50,
              // 占据父容器的宽度
              // width: double.infinity,
              // width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Transform(
                alignment: Alignment.topRight,
                transform: Matrix4.skewY(0.3),
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  color: Colors.deepOrange,
                  child: const Text("Apartment for rent!",
                      style: TextStyle(
                          fontSize: 20,
                          //首先 TextStyle 中的 height 参数值在设置后，其效果值是 fontSize 的倍数：
                          //当 height 为空时，行高默认是使用字体的量度（这个量度后面会有解释）；
                          //当 height 不是空时，行高为 height * fontSize 的大小；
                          height: 1)),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              margin: const EdgeInsets.only(top: 50.0, left: 120.0),
              constraints:
                  const BoxConstraints.tightFor(width: 200.0, height: 150.0),
              //背景装饰
              decoration: const BoxDecoration(
                  //背景径向渐变
                  gradient: RadialGradient(
                    colors: [Colors.red, Colors.orange],
                    center: Alignment.topLeft,
                    radius: .98,
                  ),

                  boxShadow: [
                    //卡片阴影
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 4.0),
                  ],),
              transform: Matrix4.rotationZ(.2),
              alignment: Alignment.center,
              child: const Text(
                '5.21',
                style: TextStyle(color: Colors.white, fontSize: 40.0),
              ),
            )
          ],
        ));
  }
}
