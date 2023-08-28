import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../res/colors.dart';
import 'device_utils.dart';

class ThemeUtils {

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color? getDarkColor(BuildContext context, Color darkColor) {
    return isDark(context) ? darkColor : null;
  }

  static Color? getIconColor(BuildContext context) {
    return isDark(context) ? Colours.dark_text : null;
  }
  
  static Color getStickyHeaderColor(BuildContext context) {
    return isDark(context) ? Colours.dark_bg_gray_ : Colours.bg_gray_;
  }

  static Color getDialogTextFieldColor(BuildContext context) {
    return isDark(context) ? Colours.dark_bg_gray_ : Colours.bg_gray;
  }

  static Color? getKeyboardActionsColor(BuildContext context) {
    return isDark(context) ? Colours.dark_bg_color : Colors.grey[200];
  }

  static StreamSubscription<dynamic>? _subscription;

  /// 设置NavigationBar样式，使得导航栏颜色与深色模式的设置相符。
  static void setSystemNavigationBar(ThemeMode mode) {
    /// 主题切换动画（AnimatedTheme）时间为200毫秒，延时设置导航栏颜色，这样过渡相对自然。
    _subscription?.cancel();
    _subscription = Stream.value(1).delay(const Duration(milliseconds: 200)).listen((_) {
      bool isDark = false;
      if (mode == ThemeMode.dark || (mode == ThemeMode.system && PlatformDispatcher.instance.platformBrightness == Brightness.dark)) {
        isDark = true;
      }
      setSystemBarStyle(isDark: isDark);
    });
  }

  /// 设置StatusBar、NavigationBar样式。(仅针对安卓)
  /// 本项目在android MainActivity中已设置，不需要覆盖设置。
  static void setSystemBarStyle({bool? isDark}) {
    if (Device.isAndroid) {

      final bool isDarkMode = isDark ?? PlatformDispatcher.instance.platformBrightness == Brightness.dark;
      debugPrint('isDark: $isDarkMode');
      final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        /// 透明状态栏
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: isDarkMode ? Colours.dark_bg_color : Colors.white,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}


/*
 * 在Dart 2.7 版本中，Dart新加入了一个重要的语法功能，叫做extension。
 * Extension的主要功能给已经存在的类添加新的member function，
 * 往里面增加新的函数。通过extension, 我们可以向诸如 Iterable, String 这样的常用类里面增加一些方便的函数。
 *
 * https://www.jianshu.com/p/6b6d75062758
 *
 */
extension ThemeExtension on BuildContext {
  bool get isDark => ThemeUtils.isDark(this);
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get dialogBackgroundColor => Theme.of(this).canvasColor;
}
