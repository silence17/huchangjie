import 'package:flutter/material.dart';
import 'package:flutter_module/utils/theme_utils.dart';

import '../res/colors.dart';

class CardView extends StatelessWidget {
  const CardView(
      {super.key,
      required this.child,
      this.bgColor,
      this.shadowColor,
      this.radius = 8.0});

  final Widget child;

  //背景色
  final Color? bgColor;

  //阴影
  final Color? shadowColor;

  //圆角，角度
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;
    final Color backgroundColor =
        bgColor ?? (isDark ? Colours.dark_bg_gray_ : Colors.white);
    final Color sColor =
        isDark ? Colors.transparent : (shadowColor ?? const Color(0x80DCE7FA));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
              // 阴影的颜色
              color: sColor,
              // 阴影与容器的距离
              offset: const Offset(1.0, 2.0),
              blurRadius: 8.0),
        ],
      ),
      child: child,
    );
  }
}
