import 'package:flutter/material.dart';

/*
 * 限定符on主要是用于对mixin进行使用限定，当一个mixin后面跟着on xxClass(这里可以是类、接口、抽象类)，
 * 那么使用这个mixin的宿主必须继承这个xxClass。如下：
 *
 * 被mixin定义的类不能实例化，不能有构造器
 * mixin不能使用extends继续其他类
 * 一个类可以混入多个mixin
 * mixin可以使用implements实现接口
 * 使用混入mixin，这不是继承关系
 *
 * 类似java 抽象类
 */
mixin ChangeNotifierMixin<T extends StatefulWidget> on State<T> {
  Map<ChangeNotifier?, List<VoidCallback>?>? _map;

  //抽象方法
  Map<ChangeNotifier?, List<VoidCallback>?>? changeNotifier();

  @override
  void initState() {
    _map = changeNotifier();
    _map?.forEach((changeNotifier, callbacks) {
      if (callbacks != null && callbacks.isNotEmpty) {
        for (var callback in callbacks) {
          changeNotifier?.addListener(callback);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _map?.forEach((changeNotifier, callbacks) {
      if (callbacks != null && callbacks.isNotEmpty) {
        for (var callback in callbacks) {
          changeNotifier?.removeListener(callback);
        }
      }
      changeNotifier?.dispose();
    });
    super.dispose();
  }
}
