import 'package:flutter/material.dart';
import 'package:flutter_module/common/mvp/i_lifecycle.dart';


abstract class IMvpView {
  BuildContext getContext();

  /// 显示Progress
  void showProgress();

  /// 关闭Progress
  void closeProgress();
}

abstract class IPresenter extends ILifecycle {}
