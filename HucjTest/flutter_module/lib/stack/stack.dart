import 'package:flutter/material.dart';

class StackDemo extends StatelessWidget {
  const StackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: Center(child: _buildStack()),
      ),
    );
  }

  Widget _buildStack() {
    return Column(
        //测试Row对齐方式，排除Column默认居中对齐的干扰
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),

          // 对齐与相对定位
          DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.red, Colors.orange.shade700]), //背景渐变
                  borderRadius: BorderRadius.circular(3.0), //3像素圆角
                  boxShadow: const [
                    //阴影
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 4.0)
                  ]),
              child: const Center(
                child: Text('center'),
              )),
          const SizedBox(
            height: 20,
          ),
          Container(
              height: 120,
              color: Colors.blue.shade50,
              child: const Align(
                // alignment: Alignment.topRight,
                // alignment: Alignment(2,0.0),
                alignment: FractionalOffset(0.2, 0.6),
                //根据子元素的缩放比
                heightFactor: 2,
                widthFactor: 3,
                child: FlutterLogo(
                  size: 60,
                ),
              )),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(" hello world "),
              Text(" I am Jack "),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Stack(
            //决定如何去对齐没有定位
            alignment: const Alignment(0.6, 0.6),
            // alignment: AlignmentDirectional.topStart,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('images/pic.jpg'),
                radius: 100,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                ),
                child: const Text(
                  'Mia B',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Positioned(left: 0, top: 0, child: Text('huchangjie')),
              const Text("无Positioned 限制",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.lineThrough,
                  ))
            ],
          )
        ]);
  }
}
