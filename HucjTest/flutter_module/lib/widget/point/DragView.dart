import 'package:flutter/material.dart';


/*
 * view跟随手势滑动
 */
class DragView extends StatefulWidget {
  const DragView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DragViewState();
  }
}

class _DragViewState extends State<DragView>
    with SingleTickerProviderStateMixin {
  double _top = 0.0;
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: _top,
              left: _left,
              child: (GestureDetector(
                child: const CircleAvatar(
                  child: Text("A"),
                ),
                //手指按下时会触发此回调
                onPanDown: (DragDownDetails e) {
                  //打印手指按下的位置(相对于屏幕)
                  print("用户手指按下：${e.globalPosition}");
                },
                //手指滑动时会触发此回调
                onPanUpdate: (DragUpdateDetails e) {
                  //用户手指滑动时，更新偏移，重新构建
                  setState(() {
                    _left += e.delta.dx;
                    _top += e.delta.dy;
                  });
                },
                onPanEnd: (DragEndDetails e) {
                  //打印滑动结束时在x、y轴上的速度
                  print(e.velocity);
                },
              )))
        ],
      ),
    );
  }
}
