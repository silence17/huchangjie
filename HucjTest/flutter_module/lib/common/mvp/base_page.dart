import 'package:flutter/material.dart';
import 'package:flutter_module/common/mvp/base_presenter.dart';
import 'package:flutter_module/common/mvp/mvps.dart';
import 'package:flutter_module/common/mvp/progress_dialog.dart';

import '../routers/fluro_navigator.dart';
import '../utils/log_utils.dart';


mixin BasePageMixin<T extends StatefulWidget, P extends BasePresenter>
    on State<T> implements IMvpView {
  P? presenter;

  bool _isShowDialog = false;

  P createPresenter();

  @override
  BuildContext getContext() {
    return context;
  }

  @override
  void closeProgress() {
    if (mounted && _isShowDialog) {
      _isShowDialog = false;
      NavigatorUtils.goBack(context);
    }
  }

  @override
  void showProgress() {
    /// 避免重复弹出
    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      try {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          barrierColor: const Color(0x00FFFFFF),
          // 默认dialog背景色为半透明黑色，这里修改为透明（1.20添加属性）
          builder: (_) {
            return WillPopScope(
              onWillPop: () async {
                // 拦截到返回键，证明dialog被手动关闭
                _isShowDialog = false;
                return Future.value(true);
              },
              child: buildProgress(),
            );
          },
        );
      } catch (e) {
        /// 异常原因主要是页面没有build完成就调用Progress。
        debugPrint(e.toString());
      }
    }
  }

  /// 可自定义Progress
  Widget buildProgress() => const ProgressDialog(hintText: '正在加载...');

  @override
  void didChangeDependencies() {
    presenter?.didChangeDependencies();
    Log.d('$T ==> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    presenter?.dispose();
    Log.d('$T ==> dispose');
    super.dispose();
  }

  @override
  void deactivate() {
    presenter?.deactivate();
    Log.d('$T ==> deactivate');
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    presenter?.didUpdateWidgets<T>(oldWidget);
    Log.d('$T ==> didUpdateWidgets');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    Log.d('$T ==> initState');
    presenter = createPresenter();
    presenter?.view = this;
    presenter?.initState();
    super.initState();
  }
}
