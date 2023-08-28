import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_module/common/mvp/base_presenter.dart';
import 'package:flutter_module/common/mvp/mvps.dart';
import 'package:oktoast/oktoast.dart';

import '../net/DioUtil.dart';
import '../net/Method.dart';
import '../utils/error_handle.dart';

class BasePagePresenter<V extends IMvpView> extends BasePresenter<V> {
  //取消request
  late HashMap<String, CancelToken> cancelTokenMap;

  BasePagePresenter() {
    cancelTokenMap = HashMap();
  }

  @override
  void dispose() {
    super.dispose();
    cancelTokenMap.forEach((key, value) {
      cancelTokenMap[key]?.cancel();
    });
  }

  /// 返回Future 适用于刷新，加载更多
  Future<dynamic> requestNetwork<T>(
    Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (isShow) {
      view.showProgress();
    }

    var cancelToken = _addCancelMap(url);
    return DioUtil.instance.requestNetwork<T>(
      method,
      url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSuccess: (data) {
        if (isClose) {
          view.closeProgress();
        }
        onSuccess?.call(data);
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
  }

  void asyncRequestNetwork<T>(
    Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (isShow) {
      view.showProgress();
    }
    var cancelToken = _addCancelMap(url);
    DioUtil.instance.asyncRequestNetwork<T>(
      method,
      url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSuccess: (data) {
        if (isClose) {
          view.closeProgress();
        }
        onSuccess?.call(data);
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
  }

  void _onError(int code, String msg, NetErrorCallback? onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    view.closeProgress();
    if (code != ExceptionHandle.cancel_error) {
      showToast(msg);
    }
    /// 页面如果dispose，则不回调onError
    if (onError != null) {
      onError(code, msg);
    }
  }

  /*
   * 缓存CancelToken，用于取消响应url
   */
  CancelToken _addCancelMap(String key) {
    if (cancelTokenMap.containsKey(key)) {
      var token = cancelTokenMap[key];
      if (token != null && !token.isCancelled) {
        token.cancel();
      }
      return cancelTokenMap[key]!;
    }

    var token = CancelToken();
    cancelTokenMap[key] = token;
    return token;
  }
}
