import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/res/colors.dart';
import 'package:flutter_module/common/utils/theme_utils.dart';
import 'package:flutter_module/common/widget/my_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {super.key,
      this.centerTitle = '',
      this.backgroundColor,
      this.actionName = '',
      this.backImg = 'assets/images/ic_back_black.png',
      this.backImgColor,
      this.onPressed,
      this.isBack = true});

  final String? centerTitle;
  final Color? backgroundColor;
  final String backImg;
  final Color? backImgColor;
  final String actionName;
  final VoidCallback? onPressed;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Colors.blue;

    final SystemUiOverlayStyle overlayStyle =
        //静态方法 ThemeData.estimateBrightnessForColor() 可用于计算任何颜色的亮度。
        ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    //右侧按钮
    final Widget action = actionName.isNotEmpty
        ? Positioned(
            right: 0.0,
            //想要应用局部主题的widget外部，包裹Theme来实现
            child: Theme(
              data: Theme.of(context).copyWith(
                buttonTheme: const ButtonThemeData(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  minWidth: 60.0,
                ),
              ),
              child: MyButton(
                key: const Key('actionName'),
                fontSize: 14,
                minWidth: null,
                text: actionName,
                textColor: context.isDark ? Colours.dark_text : Colours.text,
                backgroundColor: Colors.transparent,
                onPressed: onPressed,
              ),
            ))
        : const SizedBox.shrink();

    //返回键
    final Widget back = isBack
        ? IconButton(
            onPressed: () async {
              //返回键
              //收起键盘或者其他的情况，我们一般使用失去焦点的方式
              FocusManager.instance.primaryFocus?.unfocus();
              final isBack = await Navigator.maybePop(context);
              if (!isBack) {
                await SystemNavigator.pop();
              }
            },
            tooltip: 'Back',
            padding: const EdgeInsets.all(12.0),
            icon: Image.asset(backImg,
                color: backImgColor ?? ThemeUtils.getIconColor(context)),
          )
        : const SizedBox.shrink();

    //title
    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment: (centerTitle == null || centerTitle!.isEmpty)
            ? Alignment.centerLeft
            : Alignment.center,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Text(
          (centerTitle == null || centerTitle!.isEmpty) ? "" : centerTitle!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: bgColor,
          child: SafeArea(
            top: true,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                titleWidget,
                back,
                action,
              ],
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
